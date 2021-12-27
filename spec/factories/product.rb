require 'factory_bot'
require 'faker'

require_relative '../../lib/data/product'

FactoryBot.define do
  factory :product do
    sequence(:id) { |n| "#{n}" }
    vendor { 'A vendor' }
    title { 'A title' }
    availability { 'in stock' }
    price { '$100.00' }
    url { 'www.example.com'  }


    transient do 
      vendor_data {
        {
          name: "tenda.com",
          url: "https://www.gotenda.com/product-category/reloading/primers/pistol-primers/",
          availability_phrase: "in stock",
          selectors: {
              product: ".product",
              title: ".products-title",
              availability: ".stock",
              price: ".amount"
          }
        }
      }
    end

    initialize_with { new(vendor_data: vendor_data) }
  end
end