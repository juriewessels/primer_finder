require 'factory_bot'

require_relative '../spec_helper.rb'
require_relative '../../lib/services/snooze_product.rb'

RSpec.describe SnoozeProduct do
  let!(:redis) { Redis.new }
  let(:product_one) { attributes_for(:product, title: 'Product one').slice(:id, :title) }
  let(:product_two) { attributes_for(:product, title: 'Product two').slice(:id, :title) }

  before(:each) { redis.flushdb }
  after(:each) { redis.quit }
  after { redis.flushdb }

  it 'snoozes products correctly' do
    expect(described_class.call(product: product_one)).to eq(true)
    expect(redis.keys.length).to eq(1)
    expect(redis.keys).to eq(['snoozed_products'])
    expect(redis.hget('snoozed_products', product_one[:id])).to eq('Product one')
  end

  it 'does not allow to snooze a product twice' do
    expect(described_class.call(product: product_one)).to eq(true)
    expect(redis.hkeys('snoozed_products').length).to eq(1)
    
    expect(described_class.call(product: product_one)).to eq(false)
    expect(redis.hkeys('snoozed_products').length).to eq(1)
  end

  it 'allows for snoozing of more than one product' do
    expect(described_class.call(product: product_one)).to eq(true)
    expect(redis.hkeys('snoozed_products').length).to eq(1)
    expect(described_class.call(product: product_two)).to eq(true)
    expect(redis.hkeys('snoozed_products').length).to eq(2)
  end

  it 'expires a snooze correctly' do
    expect(
      described_class.call(product: product_one, snooze_length: 2)
    ).to eq(true)

    expect(redis.keys.length).to eq(1)
    expect(redis.keys).to eq(['snoozed_products'])
    expect(redis.hkeys('snoozed_products')).to eq([product_one[:id]])
    sleep 3

    expect(redis.keys.length).to eq(0)
  end

  it 'does' do 

  end
end