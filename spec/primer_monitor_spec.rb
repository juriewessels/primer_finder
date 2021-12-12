require 'vcr'
require_relative '../spec/spec_helper'
require_relative '../lib/find_primers'

RSpec.describe FindPrimers do
    it 'kinda works' do
      VCR.use_cassette('find_primers', match_requests_on: %i[method path]) do
        expect(FindPrimers.call).to eq('success')
      end
    end
end