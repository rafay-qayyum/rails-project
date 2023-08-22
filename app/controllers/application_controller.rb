class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
protected
  def configure_permitted_parameters
    # parameters for updating an account
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :image])
    # parameters for creating a an account
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end
end

