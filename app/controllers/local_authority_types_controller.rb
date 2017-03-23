class LocalAuthorityTypesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
    @wizard = ModelWizard.new(@local_authority_type, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@local_authority_type, session, params, local_authority_type_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_type, "Local Authority Eng Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Local Authority Eng Register", current_user).deliver_now
      flash[:notice] = "Your update has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to local_authority_types_path
    else
      render :edit
    end
  end

  private
    def local_authority_type_params
      return params unless params[:local_authority_type]

      params.require(:local_authority_type).permit(
        :current_step,
        :code,
        :name,
        :start_date,
        :end_date,
        :change_approved,
        :user_id
      )
    end
end

