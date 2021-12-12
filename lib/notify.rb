require 'net/smtp'
require_relative '../lib/callable'

class Notify

  extend Callable

  SUBJECT = "Subject: I found primers!\n\n".freeze 

  def initialize(message:)
    @message = message
  end

	def call
		notify
	end

	private

  def notify
    smtp = Net::SMTP.new(ENV['SMTP_DOMAIN'], ENV['SMTP_PORT'])
    smtp.enable_starttls

    smtp.start(ENV['EMAIL_DOMAIN'], ENV['EMAIL_USERNAME'], 
      ENV['EMAIL_PASSWORD'], :login)
    smtp.send_message("#{SUBJECT}#{@message}", ENV['EMAIL_FROM'],
      ENV['EMAIL_TO'])
    
    smtp.finish
  end

end