class TerritoriesController < ApplicationController
  before_action :set_territory

  def index
    @territories = Territory.all
  end

  def show
  end

  def new
    @wizard = ModelWizard.new(Territory, session, params).start
    @territory = @wizard.object
  end

  def create
    @wizard = ModelWizard.new(Territory, session, params, territory_params).continue
    @territory = @wizard.object
    if @wizard.save
      NotificationMailer.register_update_notification(@territory, "Territory Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Territory Register", current_user).deliver_now
      flash[:notice] = "Your new record has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @wizard = ModelWizard.new(@territory, session, params).start
  end

  def update
    @wizard = ModelWizard.new(@territory, session, params, territory_params).continue
    if @wizard.save
      NotificationMailer.register_update_notification(@territory, "Territory Register", current_user).deliver_now
      NotificationMailer.register_update_confirmation("Territory Register", current_user).deliver_now
      flash[:notice] = "Your update has been submitted, you'll recieve a confirmation email once the change is live"
      redirect_to root_path
    else
      render :edit
    end
  end

  private
    def set_territory
      @territory = Territory.find_by(id: params[:id])
    end

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
