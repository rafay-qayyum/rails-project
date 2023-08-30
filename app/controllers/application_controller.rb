class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access denied."
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:alert] = "The page you requested does not exist."
    redirect_to root_url
  end

  rescue_from ActionController::RoutingError do |exception|
    redirect_to '/404'
  end


protected
  def configure_permitted_parameters
    # parameters for updating an account
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password, :image])
    # parameters for creating an account
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
  end
end

