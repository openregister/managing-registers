class RegistersController < ApplicationController
  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register', :beta)._all_records.sort_by{|register| register.key}
  end

  def show
    @register_name = prepare_register_name(params[:register_name])
    @register = OpenRegister.register(params[:register_name].downcase, :beta)._all_records.sort_by{|register| register.name}
  end

  def select_register
    redirect_to register_records_path(params[:register])
  end

  # def new
  #   @wizard = ModelWizard.new(Country, session, params).start
  #   @country = @wizard.object
  # end
  #
  # def create
  #   @wizard = ModelWizard.new(Country, session, params, country_params).continue
  #   @country = @wizard.object
  #   if @wizard.save
  #     NotificationMailer.register_update_notification(@country, "Country Register", current_user).deliver_now
  #     NotificationMailer.register_update_confirmation("Country Register", current_user).deliver_now
  #     flash[:notice] = "Your new record has been submitted, you'll recieve a confirmation email once the change is live"
  #     redirect_to root_path
  #   else
  #     render :new
  #   end
  # end
  #
  # def edit
  #   @wizard = ModelWizard.new(@country, session, params).start
  # end
  #
  # def update
  #   @wizard = ModelWizard.new(@country, session, params, country_params).continue
  #   if @wizard.save
  #     NotificationMailer.register_update_notification(@country, "Country Register", current_user).deliver_now
  #     NotificationMailer.register_update_confirmation("Country Register", current_user).deliver_now
  #     flash[:notice] = "Your update has been submitted, you'll recieve a confirmation email once the change is live"
  #     redirect_to root_path
  #   else
  #     render :edit
  #   end
  # end

end
