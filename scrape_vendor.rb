require './callable'

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
    products.map { |product| get_data(product) }
	end

  def products
    @driver.find_elements(css: @selectors[:product])
  end

  def get_data(product)
    product_title = product.find_element(css: @selectors[:title]).text.downcase
    
    return if !product_title.include?(PRIMER_TYPE)

    { 
      vendor: @vendor[:name], 
      title: product_title, 
      stock_status: product.find_element(css: @selectors[:availability]).text.downcase,
      price: product.find_element(css: @selectors[:price]).text.downcase
    }
  end

end