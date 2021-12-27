require 'twilio-ruby'
require 'net/smtp'

require_relative 'callable.rb'

class Notify

  extend Callable

  SUBJECT = "Subject: I found primers!\n\n".freeze 
  SMS_BODY = 'I found primers!'.freeze

  def initialize(message:)
    @message = message
    @smtp_client = Net::SMTP.new(ENV['SMTP_DOMAIN'], ENV['SMTP_PORT'])
    @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], 
      ENV['TWILIO_AUTH_TOKEN'])
  end

	def call
		send_email
    send_sms
	end

	private

  def send_email
    @smtp_client.enable_starttls

    @smtp_client.start(ENV['EMAIL_DOMAIN'], ENV['EMAIL_USERNAME'], 
      ENV['EMAIL_PASSWORD'], :login)
    @smtp_client.send_message("#{SUBJECT}#{@message}", ENV['EMAIL_FROM'],
      ENV['EMAIL_TO'])
    
    @smtp_client.finish
  end

  def send_sms
    @twilio_client.messages.create(
      from: ENV['TWILIO_FROM_NUMBER'],
      to: ENV['TWILIO_TO_NUMBER'],
      body: SMS_BODY
    )  
  end

end
