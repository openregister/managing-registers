class LocalAuthorityEngsController < ApplicationController
  before_action :set_local_authority_eng, only: [:show, :edit, :update, :success]

  def index
    @local_authority_engs = LocalAuthorityEng.all
  end

  def new
    @local_authority_eng = LocalAuthorityEng.new
  end

  def show
  end

  def success
  end

  def edit
    @wizard = ModelWizard.new(@local_authority_eng, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@local_authority_eng, session, params, local_authority_eng_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_eng, "Local Authority Eng Register", "tony.worron@fco.gov.uk").deliver_now
      NotificationMailer.register_update_confirmation("Local Authority Eng Register", "tony.worron@fco.gov.uk").deliver_now
      redirect_to success_local_authority_eng_path(@local_authority_eng)
    else
      render :edit
    end
  end

  private
    def set_local_authority_eng
      @local_authority_eng = LocalAuthorityEng.find(params[:id])
    end

    def local_authority_eng_params
      return params unless params[:local_authority_eng]

      params.require(:local_authority_eng).permit(:current_step,
        :code,
        :name,
        :official_name,
        :local_authority_type,
        :start_date,
        :end_date,
        :change_approved
      )
    end
end

