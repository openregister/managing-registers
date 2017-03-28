class LocalAuthorityTypesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @wizard = ModelWizard.new(LocalAuthorityType, session, params).start
    @local_authority_type = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(LocalAuthorityType, session, params, local_authority_type_params).continue
    @local_authority_type = @wizard.object
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_type, "Local authority type Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Local authority type Register", current_user).deliver_now
      flash[:notice] = "Your new record has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @wizard = ModelWizard.new(@local_authority_type, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@local_authority_type, session, params, local_authority_type_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_type, "Local Authority Type Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Local Authority Type Register", current_user).deliver_now
      flash[:notice] = "Your update has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
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

