class RegisterController < ApplicationController

  include ApplicationHelper
  helper_method :get_all_attribute_names_prettified, :prepare_register_name

  # def index(register)
  #   @countries = OpenRegister.register(register, :beta)._all_records
  # end

  def index
    @register_name = prepare_register_name(params[:register])
    @register = OpenRegister.register(params[:register].downcase, :beta)._all_records.sort_by{|register| register.name}
  end

  def show
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

  def get_all_attribute_names_prettified(register_item)
    attribute_names = register_item.instance_variables
    attribute_names.delete(attribute_names.size)

    attribute_names.map! {|x| x.to_s.sub!('@', '').gsub('_', ' ').split.map(&:capitalize)*' '}
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
