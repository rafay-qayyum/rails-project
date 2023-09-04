module SmsTwilio
  def send_otp(to, otp)
    SmsJob.perform_later(to, otp)
  end
end
