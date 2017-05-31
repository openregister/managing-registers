class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :devise_configure_permitted_parameters, if: :devise_controller?

  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, alert: exception.message }
    end
  end

  protected

  def devise_configure_permitted_parameters
    devise_parameter_sanitizer.permit :accept_invitation, keys: [:full_name, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: [:full_name, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: [:full_name, :email, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:full_name, :email, :password, :password_confirmation, :current_password, :registers]
  end

end
