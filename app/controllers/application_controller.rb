class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :devise_configure_permitted_parameters, if: :devise_controller?

  protected

  def devise_configure_permitted_parameters
    devise_parameter_sanitizer.permit :invite, keys: [:email, :role, :registers]
    devise_parameter_sanitizer.permit :accept_invitation, keys: [:full_name, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: [:full_name, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: [:full_name, :email, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:full_name, :email, :password, :password_confirmation, :current_password, :registers]
  end
end
