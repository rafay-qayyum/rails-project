class SmsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 5
  def perform(to, otp)
    client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])

    client.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: to,
      body: "Your OTP: #{otp}"
    )
  end
end
