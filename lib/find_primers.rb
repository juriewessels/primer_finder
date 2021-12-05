require 'byebug'
require 'dotenv/load'
require 'dotenv'
require 'json'
require 'selenium-webdriver'
require 'uri'
require_relative '../lib/scrape_vendor'
require_relative '../lib/callable'

Dotenv.load


class FindPrimers

  extend Callable

  def initialize
    @vendors = JSON.parse(File.read('./vendors.json'), symbolize_names: true)
  end

  def call
    options =
      Selenium::WebDriver::Chrome::Options.new.tap { |opts| opts.add_argument('--headless') }
    driver =  Selenium::WebDriver.for :chrome, capabilities: [options]

    results = 
      @vendors.map {|vendor| ScrapeVendor.call(driver: driver, vendor: vendor) }

    results.flatten.compact
  end

end
