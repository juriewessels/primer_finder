require 'byebug'
require 'dotenv'
require 'redis'
require 'selenium-webdriver'

require_relative 'scrape_vendor.rb'
require_relative 'callable.rb'
require_relative 'notify.rb'
require_relative 'format_message.rb'

Dotenv.load

class FindPrimers

  extend Callable

  def initialize(vendors:)
    @vendors = vendors
    @logger = Logger.new(STDOUT)
  end

  def call
    @logger.info('Finding primers...')

    products = @vendors.map do |vendor| 
      ScrapeVendor.call(driver: selenium_driver, vendor: vendor)
    end.flatten

    # This is nar nar. 
    active_products = reject_snoozed(reject_out_of_stock(products))

    if active_products.empty?
      @logger.info('No new primers found.')
      return
    end

    Notify.call(message: FormatMessage.call(products: active_products))
    @logger.info('Primers found! Notifications sent.')
    selenium_driver.quit
  end

  private

  def selenium_driver
    options = Selenium::WebDriver::Chrome::Options.new

    if chrome_bin = ENV['GOOGLE_CHROME_BIN']
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.binary = chrome_bin
    end

    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    
    @logger.info('--------------------CHROME OPTIONS:----------------')
    @logger.info(options.as_json)

    puts '--------------------CHROME OPTIONS:----------------'
    puts options.as_json

    Selenium::WebDriver::Chrome::Service.driver_path = '/app/.chromedriver/bin/chromedriver'
    Selenium::WebDriver.for :chrome, capabilities: [options]
  end

  def reject_out_of_stock(products)
    products.reject { |product| !product.has_stock? }
  end

  def reject_snoozed(products)
    redis = Redis.new
    snoozed_products = redis.hkeys('snoozed_products')
    redis.quit
    products.reject { |product| snoozed_products.include?(product.id) }
  end

end
