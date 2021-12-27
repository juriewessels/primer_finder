require 'byebug'
require 'dotenv'
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
