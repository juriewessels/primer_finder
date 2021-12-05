require 'byebug'
require 'dotenv/load'
require 'dotenv'
require 'json'
require 'selenium-webdriver'
require 'uri'
require './scrape_vendor'
require './callable'

Dotenv.load


class FindPrimers

  extend Callable

  def initialize
    @vendors = JSON.parse(File.read('./vendors.json'), symbolize_names: true)
  end

  def call
    find_primers
  end

  private

  def find_primers
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    driver =  Selenium::WebDriver.for :chrome, options: options

    vendor_data = @vendors.map do |vendor| 
      ScrapeVendor.call(driver: driver, vendor: vendor) 
    end

    vendor_data.flatten.compact
  end

end
