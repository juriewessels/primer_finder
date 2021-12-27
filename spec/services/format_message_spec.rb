require 'factory_bot'

require_relative '../spec_helper.rb'
require_relative '../../lib/services/format_message.rb'

RSpec.describe FormatMessage do
  let(:product_one) { build(:product, title: 'product one') }
  let(:product_two) { build(:product, title: 'product two') }
  let(:product_three) { build(:product, availability: 'out of stock') }

  let(:products) {[product_one, product_two, product_three]}

  let(:formatted_message) do 
    "vendor: A vendor\ntitle: product one\navailability: in stock\nprice: $100.00\n"\
    "url: www.example.com\nsnooze: http://localhost:4567/snooze?product[id]="\
    "#{product_one.id}&product[title]=product+one\n\n"\
    "vendor: A vendor\ntitle: product two\navailability: in stock\nprice: $100.00\n"\
    "url: www.example.com\nsnooze: http://localhost:4567/snooze?product[id]="\
    "#{product_two.id}&product[title]=product+two"
  end

  subject(:call) { described_class.call(products: products) }

  it 'returns a correctly formatted message' do
    expect(call).to match(formatted_message)
  end
end