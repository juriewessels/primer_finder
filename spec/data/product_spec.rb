require 'digest/sha1'
require 'selenium-webdriver'

require_relative '../spec_helper'
require_relative '../../lib/data/product'

RSpec.describe Product do
  
  let(:vendor) do 
    {
      name: "tenda.com", 
      url: "www.example.com", 
      availability_phrase: "out of stock", 
      selectors: {
        product: ".product", 
        title: ".products-title", 
        availability: ".stock", 
        price: ".amount"
      }
    }
  end

  let(:element) { instance_double(Selenium::WebDriver::Element) }

  before(:each) do
    allow(Selenium::WebDriver::Element).to receive(:new).and_return(element)  
  end

  subject(:product) do 
    described_class.new(vendor_data: vendor, source_data: element)  
  end

  context '.id and .title' do
    before(:each) do
      allow(element).
        to receive_message_chain(:find_element, :text).
        with(css: '.products-title').
        with(no_args).
        and_return('product title for small primers')
    end

    let(:title) { 'product title for small primers' }
    let(:hashed_title) { Digest::SHA1.hexdigest(title) }

    it 'returns a correctly hashed id' do
      expect(product.id).to eq(hashed_title)
    end

    it 'returns a correctly hashed id' do
      expect(product.title).to eq(title)
    end
  end

  context '.vendor' do 
    it 'returns a correctl vendor name' do
      expect(product.vendor).to eq(vendor[:name])
    end
  end

  context '.status' do 
    before(:each) do
        allow(element).
          to receive_message_chain(:find_element, :text).
          with(css: '.stock').
          with(no_args).
          and_return('in stock')
      end

      it 'returns a correctly hashed id' do
        expect(product.availability).to eq('in stock')
      end
  end

  context '.price' do 
    before(:each) do
        allow(element).
          to receive_message_chain(:find_element, :text).
          with(css: '.amount').
          with(no_args).
          and_return('$100.00')
      end

      it 'returns a correctly hashed id' do
        expect(product.price).to eq('$100.00')
      end
  end

  context '.url' do 
    it 'returns a correctly hashed id' do
      expect(product.url).to eq('www.example.com')
    end
  end

  context 'setting attributes using Factory Bot' do 
    let(:product_attributes) { attributes_for(:product) }

    it 'allows the setting of attributes' do 
      expect(product_attributes).to match(
        id: '1',
        vendor:  'A vendor',
        title:  'A title',
        availability:  'in stock',
        price:  '$100.00',
        url:  'www.example.com'
      )
    end
  end

end