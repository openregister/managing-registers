class TerritoriesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def success
  end

  def edit
    @wizard = ModelWizard.new(@territory, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@territory, session, params, territory_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@territory, "Territory Register", "tony.worron@fco.gov.uk").deliver_now
      NotificationMailer.register_update_confirmation("Territory Register", "tony.worron@fco.gov.uk").deliver_now
      redirect_to success_territory_path(@territory)
    else
      render :edit
    end
  end

  private
    def territory_params
      return params unless params[:territory]

      params.require(:territory).permit(
        :current_step,
        :name,
        :official_name,
        :start_date,
        :end_date,
        :code,
        :change_approved,
        :user_id
      )
    end
end
