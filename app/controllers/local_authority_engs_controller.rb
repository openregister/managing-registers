class LocalAuthorityEngsController < ApplicationController
  before_action :set_local_authority_eng

  def index
    @local_authority_engs = LocalAuthorityEng.all
  end

  def show
  end

  def new
    @wizard = ModelWizard.new(LocalAuthorityEng, session, params).start
    @local_authority_eng = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(LocalAuthorityEng, session, params, local_authority_eng_params).continue
    @local_authority_eng = @wizard.object
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_eng, "Local authority eng Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Local authority eng Register", current_user).deliver_now
      flash[:notice] = "Your new record has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @wizard = ModelWizard.new(@local_authority_eng, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@local_authority_eng, session, params, local_authority_eng_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_eng, "Local Authority Eng Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Local Authority Eng Register", current_user).deliver_now
      flash[:notice] = "Your update has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
    else
      render :edit
    end
  end

  private
    def set_local_authority_eng
      @local_authority_eng = LocalAuthorityEng.find_by(id: params[:id]
    end

    def local_authority_eng_params
      return params unless params[:local_authority_eng]

      params.require(:local_authority_eng).permit(
        :current_step,
        :code,
        :name,
        :official_name,
        :local_authority_type,
        :start_date,
        :end_date,
        :change_approved,
        :user_id
      )
    end
end

