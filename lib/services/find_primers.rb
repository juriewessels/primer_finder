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
    @logger.info("Finding primers...")

    products = @vendors.map do |vendor| 
      ScrapeVendor.call(driver: selenium_driver, vendor: vendor)
    end.flatten

    # This is nar nar. 
    active_products = reject_snoozed(reject_out_of_stock(products))

    if active_products.empty?
      @logger.info("No new primers found.")
      return
    end

    Notify.call(message: FormatMessage.call(products: active_products))
    @logger.info("Primers found! Notifications sent.")
  end

  private

  def selenium_driver
    @logger.info("HERRERERE JRELKRJELKJREL #{ENV.fetch('GOOGLE_CHROME_BIN', nil)}")

    options =
      Selenium::WebDriver::Chrome::Options.new.tap do |opts| 
        opts.add_argument('--headless')
        opts.binary = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
      end
    
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
