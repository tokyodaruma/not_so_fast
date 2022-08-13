require 'twilio-ruby'

class SendSmsService < ApplicationService
  attr_reader :message

  def initialize(message)
    @message = message
    # probably pass in the user as well so you can get the phone number?
  end

  def call
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    client.messages.create(
      from: ENV['TWILIO_NUMBER'], # Your Twilio number
      to: '+8109056080842', # User mobile phone number
      body: @message
    )
  end
end
