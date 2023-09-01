# app/controllers/phone_verifications_controller.rb
class PhoneVerificationsController < ApplicationController
  include SmsTwilio

  #GET /phone_verifications
  def edit
    authorize! :edit, current_user
    @current_user = current_user

  end

  # POST /phone_verifications
  def update
    authorize! :update, current_user
    if current_user.update(phone_number: params[:student][:phone_number])
      otp = rand(10000..99999)
      otp_expiration = Time.now + 10.minutes # Set OTP expiration time


      Rails.cache.write( current_user.phone_number, otp, expires_in: 10.minutes)
      send_otp(current_user.phone_number, otp)
      flash[:notice] = "Your OTP is sent to your phone number"
      redirect_to verify_phone_path
    else
      flash[:alert] = "Could not Send OTP"
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /verify_phone
  def verify
    authorize! :verify, current_user
    if !params[:otp].blank? and !params[:otp].nil?
      debugger
      @otp = Rails.cache.read(current_user.phone_number)
      if current_user && @otp == params[:otp].to_i
        current_user.update(phone_verified: true)
        flash[:notice] = "Phone number verified successfully"
        redirect_to root_path
      else
        flash[:alert] = "OTP is incorrect"
        render 'verify'
      end
    else
      render 'verify'
    end
  end

  private

  def current_user
    current_instructor || current_student
  end
end
