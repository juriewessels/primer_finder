require 'byebug'
require 'vcr'
require 'webmock/rspec'

require 'dotenv'
Dotenv.load('.env.test')

VCR.configure do |c|
  # the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.ignore_localhost = false
  # your HTTP request service.
  c.hook_into :webmock
end

RSpec.configure do |config|
  # # Enable flags like --only-failures and --next-failure
  # config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end