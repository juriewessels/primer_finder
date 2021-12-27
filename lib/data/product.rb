require 'digest/sha1'
require 'rack'

class Product 

  attr_writer :id, :vendor, :title, :availability, :price, :url

  def initialize(vendor_data: {}, source_data: nil)
    @vendor_data = vendor_data
    @selectors = vendor_data[:selectors]
    @source_data = source_data
  end

  def id
    @id ||= Digest::SHA1.hexdigest(title)
  end

  def title
    @title ||= 
      @source_data.find_element(css: @selectors[:title]).text.downcase
  end

  def vendor
    @vendor ||= @vendor_data[:name] || {}
  end

  def availability
    @availability ||= 
      @source_data.find_element(css: @selectors[:availability]).text.downcase
  end

  def has_stock?
    availability == @vendor_data[:availability_phrase]
  end

  def price
    @price ||= 
      @source_data.find_element(css: @selectors[:price]).text.downcase
  end

  def url
    @url ||= @vendor_data[:url]
  end

  def description
    "vendor: #{vendor}\ntitle: #{title}\navailability: #{availability}\n"\
    "price: #{price}\nurl: #{url}\n"\
    "snooze: http://localhost:4567/snooze?#{snooze_query}"
  end

  def matches_primer_type?(primer_type)
    product_title.include?(PRIMER_TYPE)
  end

  def snooze_query
    Rack::Utils.build_nested_query(product: {id: id, title: title})
  end

end
