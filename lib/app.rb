require 'byebug'
require 'sinatra'
require 'redis'
require 'uri'

require_relative '../lib/services/snooze_product'

get '/snooze' do
  product = params['product']
  result = 
    SnoozeProduct.call(product: { id: product['id'], title: product['title'] })

  if result == true
    return erb 'Product snoozed' 
  end

  erb 'Product could not be snoozed'
end
