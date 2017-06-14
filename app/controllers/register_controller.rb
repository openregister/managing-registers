class RegisterController < ApplicationController

  include ApplicationHelper, RegisterHelper

  @register_phase = Rails.configuration.register_phase

  before_action :confirm, only: [:create]

  def index
    @changes = Change.where(register_name: params[:register])
                     .joins("LEFT OUTER JOIN statuses on statuses.change_id = changes.id")
                     .where('statuses.id is null')

    @register = get_register(params[:register])._all_records
    @register[0].try(:name) ? @register = @register.sort_by(&:name) : @register = @register.sort_by(&:key)
  end

  def new
    @register = get_register(params[:register])
    @form = JSON.parse(params.to_json)
  end

  def edit
    @register = get_register(params[:register])

    @form = convert_register_json(
        OpenRegister.record(params[:register].downcase, params[:id], @register_phase)
    ) if @form.nil?
  end

  def confirm
    return true if params[:data_confirmed]
    @register = get_register(params[:register])

    @current_register_record = OpenRegister.record(params[:register].downcase,
                        params[params[:register].downcase.to_sym],
                        @register_phase)

    if @current_register_record != nil
      @current_register_record = convert_register_json(@current_register_record)
    end

    render 'confirm'
    false
  end

  def create
    fields = get_register(params[:register]).fields

    payload = generate_canonical_object(fields, params)

    @change = Change.new(register_name: params[:register], payload: payload, user_id: current_user.id)
    @change.save

    RegisterUpdatesMailer.register_update_request(@change, current_user).deliver_now
    RegisterUpdatesMailer.register_update_receipt(@change, current_user).deliver_now

    flash[:notice] = 'Your update has been submitted, you\'ll recieve a confirmation email once the change is live'
    redirect_to action: 'index', register: params[:register]
  end

end
