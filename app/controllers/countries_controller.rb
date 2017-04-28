class CountriesController < ApplicationController
  before_action :set_country

  def index
    @countries = Country.all
  end

  def show
  end

  def new
    @wizard = ModelWizard.new(Country, session, params).start
    @country = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(Country, session, params, country_params).continue
    @country = @wizard.object
    if @wizard.save
      NotificationMailer.register_update_notification(@country, "Country Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Country Register", current_user).deliver_now
      flash[:notice] = "Your new record has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
    else
      render :new
    end
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
      redirect_to root_path
    else
      render :edit
    end
  end

  private
    def set_country
      @country = Country.find_by(id: params[:id])
    end

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
