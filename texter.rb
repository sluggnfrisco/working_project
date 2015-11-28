# https://www.twilio.com/docs/tutorials/walkthrough/server-notifications/ruby/rails#0

require 'twilio-ruby'

class Texter
  attr_reader :contacts, :sender

  def initialize
    environment = YAML.load_file('application.yml')
    account_sid = environment['TWILIO_ACCOUNT_SID']
    auth_token = environment['TWILIO_AUTH_TOKEN']

    @client = Twilio::REST::Client.new(account_sid, auth_token)
    @contacts = environment['contact_book']
    @default_from = @contacts['me']
  end

  def send_to(name, message = 'hello!')
    recipient_num = self.contacts[name.downcase]
    sender_num = self.default_from
    send_message(sender_num, recipient_num, message, media_url)
  end

  # set up a client to talk to the Twilio REST API
  def send_message(from_num, to_num, body, media_url = nil)
    message_hash = {
      from: from_num,
      to: to_num,
      body: body,
    }
    message_hash[:media_url] = media_url if media_url

    self.client.account.messages.create(message_hash)
  end
end

texter = Texter.new
