require 'twilio-ruby'

@twilio_number = ENV['TWILIO_NUMBER']
@client = Twilio::REST::Client.new(
  ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
)

# custom error handling below

rescue_from StandardError do |exception|
   trigger_sms_alerts(exception)
end

def trigger_sms_alerts(e)
  @alert_message = "
    [This is a test] ALERT!
    It appears the server is having issues.
    Exception: #{e}.
    Go to: http://newrelic.com for more details."
  @image_url = "http://howtodocs.s3.amazonaws.com/new-relic-monitor.png"

  @admin_list = YAML.load_file('config/administrators.yml')     # load admins

  begin
    @admin_list.each do |admin|
      phone_number = admin['phone_number']
      send_message(phone_number, @alert_message, @image_url)
    end
  rescue
    puts "uh-oh, admin list error"
  end
end

private

def send_message(phone_number, alert_message, image_url)
  @twilio_number = ENV['TWILIO_NUMBER']
  @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  message = @client.account.messages.create(    # sends message
    :from => @twilio_number,
    :to => phone_number,
    :body => alert_message,
    # US phone numbers can make use of an image as well.
    # :media_url => image_url
  )
  puts message.to
end
