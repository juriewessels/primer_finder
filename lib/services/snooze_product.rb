require 'redis'
require_relative 'callable.rb'

class SnoozeProduct

  extend  Callable

  SNOOZE_SEC = 300

  def initialize(product:, snooze_length: SNOOZE_SEC)
    @product = product
    @snooze_length = snooze_length
    @redis = Redis.new
  end

  def call    
    snoozed_products = @redis.hkeys('snoozed_products')
    product_id = @product[:id]

    return false if snoozed_products.include?(product_id)

    @redis.hset('snoozed_products', product_id, @product[:title])
    @redis.expire('snoozed_products', @snooze_length)
    @redis.quit
    
    return true
  end

end