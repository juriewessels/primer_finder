require 'byebug'
require 'factory_bot'
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

  # Configure FactoryBot
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

