require_relative 'callable.rb'
require_relative '../data/product.rb'

class ScrapeVendor

	extend Callable

  PRIMER_TYPE = 'small pistol'.freeze

	def initialize(driver:, vendor:)
		@driver = driver
    @vendor = vendor
    @selectors = @vendor[:selectors]
	end

	def call
		scrape_vendor
	end

	private

	def scrape_vendor
		@driver.navigate.to URI.join(@vendor[:url])
    
    product_data.map do |datum| 
      Product.new(vendor_data: @vendor, source_data: datum) 
    end
	end

  def product_data
    @driver.find_elements(css: @selectors[:product])
  end

end