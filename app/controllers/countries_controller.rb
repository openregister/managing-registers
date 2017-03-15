class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :success]

  def index
    @countries = Country.all
  end

  def new
    @country = Country.new
  end

  def show
  end

  def success
  end

  def edit
    @wizard = ModelWizard.new(@country, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@country, session, params, country_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@country, "Country Register").deliver_now
      redirect_to success_country_path(@country)
    else
      render :edit
    end
  end

  private
    def set_country
      @country = Country.find(params[:id])
    end

    def country_params
      return params unless params[:country]

      params.require(:country).permit(:current_step,
        :name,
        :citizen_name,
        :official_name,
        :start_date,
        :end_date,
        :code,
        :change_approved
      )
    end
end
