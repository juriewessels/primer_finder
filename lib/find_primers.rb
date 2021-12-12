require 'byebug'
require 'dotenv'
require 'selenium-webdriver'
require_relative '../lib/scrape_vendor'
require_relative '../lib/callable'
require_relative '../lib/notify'
require_relative '../lib/format_message'

Dotenv.load

class FindPrimers

  extend Callable

  def initialize(vendors:)
    @vendors = vendors
  end

  def call
    products = @vendors.map do |vendor| 
      ScrapeVendor.call(driver: selenium_driver, vendor: vendor)
    end

    Notify.call(message: FormatMessage.call(products: products.flatten))
  end

  private

  def selenium_driver
    options =
      Selenium::WebDriver::Chrome::Options.new.tap do |opts| 
        opts.add_argument('--headless') 
      end
    
    Selenium::WebDriver.for :chrome, capabilities: [options]
  end

end
