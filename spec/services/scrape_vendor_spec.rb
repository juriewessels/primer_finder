require 'selenium-webdriver'

require_relative '../spec_helper.rb'
require_relative '../../lib/services/scrape_vendor.rb'

RSpec.describe ScrapeVendor do

    let(:driver) do
    	options =
    	  Selenium::WebDriver::Chrome::Options.new.tap do |opts| 
    	    opts.add_argument('--headless') 
    	  end
    	
    	Selenium::WebDriver.for :chrome, capabilities: [options]
    end

    let(:vendors) do 
      JSON.parse(File.read('./spec/fixtures/vendors.json'), 
        symbolize_names: true)
    end

    let(:products) do
      JSON.parse(File.read('./spec/fixtures/products.json'), 
        symbolize_names: true)
    end

    subject(:call) { described_class.call(driver: driver, vendor: vendors[0]) }

    it 'returns the correct products for the vendor' do
      VCR.use_cassette('scrape_vendor', match_requests_on: %i[method path]) do
        expect(call.length).to eq 19
      end
    end
end