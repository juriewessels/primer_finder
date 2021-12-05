require 'byebug'
require 'dotenv/load'
require 'dotenv'
require 'selenium-webdriver'
require 'uri'

Dotenv.load


class PrimerMonitor

  VENDORS = [
    {
      name: 'tenda.com',
      url: 'https://www.gotenda.com/product-category/reloading/primers/'\
        'pistol-primers/',
      selectors: {
        product: '.product',
        title: '.products-title',
        availability: '.stock',
        availability_phrase: 'out of stock',
        price: '.amount'
      }
    },
    {
      name: 'tesro.com',
      url: 'https://www.tesro.ca/reloading/primers.html?limit=all',
      selectors: {
        product: '.products-grid > .item',
        title: '.product-name',
        availability: '.availability > span',
        availability_phrase: 'out of stock',
        price: '.price'
      },
    },
    {
      name: 'budgetshootersupply.com',
      url: 'https://budgetshootersupply.ca/product-category/rifle-pistol-reloading'\
        '-components/primers/small-pistol-primers/',
      selectors: {
        product: '.products-grid > .item',
        title: '.product-name',
        availability: '.availability > span',
        availability_phrase: 'out of stock',
        price: '.price'
      },
    }
  ]




  def self.get_availability
    VENDORS.each do |vendor|
      get_page(vendor)
    end
    
  end

  private

  def self.get_page(vendor)
    selectors = vendor[:selectors]

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    driver =  Selenium::WebDriver.for :chrome, options: options

    driver.navigate.to URI.join(vendor[:url])
    all_products = driver.find_elements(css: selectors[:product])

    monitored_products = all_products.map do |product|
      product_title = product.find_element(css: selectors[:title]).text.downcase
      next if !product_title.include?('small pistol')

      product_stock_status = 
        product.find_element(css: selectors[:availability]).text.downcase
      
      product_price = 
        product.find_element(css: selectors[:price]).text.downcase


      { 
        vendor: vendor[:name], 
        title: product_title, 
        stock_status: product_stock_status, 
        price: product_price 
      }
    end

    puts monitored_products

    monitored_products.compact
  end

end
