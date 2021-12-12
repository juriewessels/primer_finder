require 'byebug'
require 'vcr'
require 'webmock/rspec'

require 'dotenv'
Dotenv.load('.env.test')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.ignore_localhost = false
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end