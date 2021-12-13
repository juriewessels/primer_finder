require_relative '../spec/spec_helper'
require_relative '../lib/notify'

RSpec.describe Notify do
  let(:message_body) do 
    "vendor: tenda.com\ntitle: federal small pistol magnum primers, no200,"\
    " 1000/box\nstock_status: in stock\nprice: $89.99\n"
  end

  let(:message) do
    "Subject: I found primers!\n\nvendor: tenda.com\ntitle: federal small"\
    " pistol magnum primers, no200, 1000/box\nstock_status: in stock\nprice:"\
    " $89.99\n"
  end

  subject(:call) { described_class.call(message: message_body) }

  let(:smtp) { instance_double(Net::SMTP) }
  let(:twilio_client) { instance_double(Twilio::REST::Client) }

  before(:each) do
    allow(Net::SMTP).to receive(:new).and_return(smtp)
    allow(smtp).to receive(:start)
    allow(smtp).to receive(:enable_starttls)
    allow(smtp).to receive(:send_message)
    allow(smtp).to receive(:finish)

    allow(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
    allow(twilio_client).to receive_message_chain(:messages, :create)
  end

  # This is a little questionable?
  it 'correctly sends notifications' do
    VCR.use_cassette('notify', match_requests_on: %i[method path]) do
      call
      expect(smtp).to have_received(:start)
      expect(smtp).to have_received(:enable_starttls)
      expect(smtp).to have_received(:send_message)
        .with(message, ENV['EMAIL_FROM'], ENV['EMAIL_TO'])
      expect(smtp).to have_received(:finish)

      expect(twilio_client.messages).to have_received(:create)
    end
  end
end