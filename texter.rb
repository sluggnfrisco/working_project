# https://www.twilio.com/docs/tutorials/walkthrough/server-notifications/ruby/rails#0

require 'twilio-ruby'
require 'yaml'

class Texter
  attr_reader :client, :contacts, :default_from

  def initialize
    ENV = YAML.load_file('application.yml')
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token = ENV['TWILIO_AUTH_TOKEN']

    @client = Twilio::REST::Client.new(account_sid, auth_token)
    @contacts = ENV['contact_book']
    @default_from = @contacts['me']
  end

  def send_to(name, message = 'hello!', media_url = nil)
    recipient_num = self.contacts[name.downcase]
    sender_num = self.default_from
    send_message(sender_num, recipient_num, message, media_url)
    puts "Message sent to #{name}"
  end

  # set up a client to talk to the Twilio REST API
  def send_message(from_num, to_num, body, media_url)
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
# texter.send_to('ly', 'wanna go brush teef?')
