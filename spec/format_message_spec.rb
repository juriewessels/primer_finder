require_relative '../spec/spec_helper'
require_relative '../lib/format_message'

RSpec.describe FormatMessage do
  let(:products) do 
    JSON.parse(File.read('./spec/fixtures/products.json'), 
      symbolize_names: true)
  end

  let(:formatted_message) do 
    "vendor: tenda.com\ntitle: federal small pistol magnum primers, no200,"\
    " 1000/box\nstock_status: in stock\nprice: $89.99\n"
  end

  subject(:call) { described_class.call(products: products) }

  it 'returns a correctly formatted message' do
    expect(call).to match(formatted_message)
  end
end