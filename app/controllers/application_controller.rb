class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    # parameters for updating a student
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :image])
    # parameters for updating a instrcutor
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :image])
    # parameters for creating a student
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    # parameters for creating a instrcutor
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end
end

