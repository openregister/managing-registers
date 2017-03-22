class LocalAuthorityEngsController < ApplicationController
  load_and_authorize_resource

  def index
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

