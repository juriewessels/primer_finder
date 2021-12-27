require_relative 'callable.rb'

class FormatMessage

  extend Callable

  def initialize(products:)
    @products = products
  end

  def call
    format_message 
  end

  private

  def format_message
    formatted = products_with_stock.map { |product| product.description }
    formatted.join("\n\n")
  end

  def products_with_stock
    @products.select { |product| product.has_stock? }
  end

end