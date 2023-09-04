module SmsTwilio
  def send_otp(to, otp)
    SmsWorker.perform_async(to, otp)
  end
end
