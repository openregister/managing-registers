class LocalAuthorityTypesController < ApplicationController
  before_action :set_local_authority_type, only: [:show, :edit, :update, :success]

  def index
    @local_authority_types = LocalAuthorityType.all
  end

  def new
    @local_authority_type = LocalAuthorityType.new
  end

  def show
  end

  def success
  end

  def edit
    @wizard = ModelWizard.new(@local_authority_type, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@local_authority_type, session, params, local_authority_type_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@local_authority_type, "Local Authority Eng Register", "tony.worron@fco.gov.uk").deliver_now
      NotificationMailer.register_update_confirmation("Local Authority Eng Register", "tony.worron@fco.gov.uk").deliver_now
      redirect_to success_local_authority_type_path(@local_authority_type)
    else
      render :edit
    end
  end

  private
    def set_local_authority_type
      @local_authority_type = LocalAuthorityType.find(params[:id])
    end

    def local_authority_type_params
      return params unless params[:local_authority_type]

      params.require(:local_authority_type).permit(:current_step,
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

