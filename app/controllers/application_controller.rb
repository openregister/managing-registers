class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :devise_configure_permitted_parameters, if: :devise_controller?
  before_action :registers_client

  include CanCan::ControllerAdditions
  include Permissions::ControllerMethods

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, alert: exception.message }
    end
  end

  rescue_from PermissionError do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_url, alert: exception.message }
    end
  end

protected

  def registers_client
    @registers_client ||= RegistersClient::RegisterClientManager.new
  end

  def devise_configure_permitted_parameters
    devise_parameter_sanitizer.permit :invite, keys: %i[email admin]
    devise_parameter_sanitizer.permit :accept_invitation, keys: %i[full_name password password_confirmation admin]
    devise_parameter_sanitizer.permit :sign_up, keys: %i[full_name email password password_confirmation admin]
    devise_parameter_sanitizer.permit :sign_in, keys: %i[full_name email password admin]
    devise_parameter_sanitizer.permit :account_update, keys: %i[full_name email password password_confirmation current_password registers admin]
  end
end
