# app/controllers/phone_verifications_controller.rb
class PhoneVerificationsController < ApplicationController
  include SmsTwilio

  #GET /phone_verifications
  def edit
    authorize! :edit, current_user
    @current_user = current_user

  end

  # PATCH /phone_verifications
  def update
    authorize! :update, current_user
    if Student.where(phone_number: params[:phone_number]).exists? or Instructor.where(phone_number: params[:phone_number]).exists?
      render json: {success: false, message: "Phone number already exists"} and return
    end

    if current_user.update(phone_number: params[:phone_number], phone_verified: false)
      otp = rand(10000..99999)
      otp_expiration = Time.now + 10.minutes # Set OTP expiration time
      Rails.cache.write( current_user.phone_number, otp, expires_in: 10.minutes)
      send_otp(current_user.phone_number, otp)
      flash[:notice] = "Your OTP is sent to your phone number"
      render json: {success: true}
    else
      render json: {success: false, message: "Something went wrong"} 
    end
  end

  # GET /verify_phone
  def verify
    authorize! :verify, current_user
    if current_user.phone_verified?
      flash[:notice] = "Phone number already verified"
      redirect_to root_path and return
    end
    if !params[:otp].blank? and !params[:otp].nil?
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
