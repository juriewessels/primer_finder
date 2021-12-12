require_relative '../lib/callable'

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
    formatted = products_with_stock.map do |product|
        product.each_with_object('') do |(key, value), memo|
          memo << "#{key}: #{value}\n"
          memo
        end
      end

    formatted.join("\n\n")
  end

  def products_with_stock
    @products.select { |product| product[:stock_status] != 'out of stock' }
  end

end