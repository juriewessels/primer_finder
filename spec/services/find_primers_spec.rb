require_relative '../../spec/spec_helper'
require_relative '../../lib/services/find_primers'

RSpec.describe FindPrimers do

    let(:vendors) do 
      JSON.parse(File.read('./spec/fixtures/vendors.json'), 
        symbolize_names: true)
    end

    before(:each) do
      allow(ScrapeVendor).to receive(:call)
      allow(Notify).to receive(:call)
      allow(FormatMessage).to receive(:call)
    end

    subject(:call) { described_class.call(vendors: vendors) }

    it 'calls the corrects classes' do
      VCR.use_cassette('find_primers', match_requests_on: %i[method path]) do
        call

        expect(ScrapeVendor).to have_received(:call)
          .with(hash_including(vendor: vendors[0]))
        
        expect(ScrapeVendor).to have_received(:call)
          .with(hash_including(vendor: vendors[1]))

        expect(Notify).to have_received(:call)
        expect(FormatMessage).to have_received(:call)
      end
    end
end