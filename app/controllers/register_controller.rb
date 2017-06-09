class RegisterController < ApplicationController

  include ApplicationHelper, RegisterHelper

  @register_phase = Rails.configuration.register_phase

  before_action :confirm, only: [:create]

  def index
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

    Change.new(register_name: params[:register], payload: payload, user_id: current_user.id).save

    flash[:notice] = 'Your update has been submitted, you\'ll recieve a confirmation email once the change is live'
    redirect_to controller: 'home', action: 'index'

  end

  def generate_canonical_object(fields, params)
    payload = {}
    fields.sort.each do |field|
      if params[field.to_sym].nil? != true && params[field.to_sym].empty? != true
        payload[field] = params[field.to_sym].to_s
      end
    end
    payload
  end

  def get_register(register_name)
    OpenRegister.register(register_name.downcase, @register_phase)
  end

end