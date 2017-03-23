class CountriesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
    @wizard = ModelWizard.new(@country, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@country, session, params, country_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@country, "Country Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Country Register", current_user).deliver_now
      flash[:notice] = "Your update has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to countries_path
    else
      render :edit
    end
  end

  private
    def country_params
      return params unless params[:country]

      params.require(:country).permit(
        :current_step,
        :name,
        :citizen_name,
        :official_name,
        :start_date,
        :end_date,
        :code,
        :change_approved,
        :user_id
      )
    end
end
