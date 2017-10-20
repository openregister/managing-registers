class RegisterController < ApplicationController

  include ApplicationHelper, RegisterHelper

  before_action :initialize_controller, only: [:create]
  before_action :confirm, only: [:create]

  def index
    @changes = Change.joins("LEFT OUTER JOIN statuses on statuses.change_id = changes.id")
                     .where("register_name = '#{params[:register]}' AND statuses.status = 'pending'")

    @register = get_register(params[:register])._all_records
    @register[0].try(:name) ? @register = @register.sort_by(&:name) : @register = @register.sort_by(&:key)
  end

  def new
    @register = get_register(params[:register])
    @form = JSON.parse(params.to_json)
  end

  def edit
    @changes = Change.joins("LEFT OUTER JOIN statuses on statuses.change_id = changes.id")
                     .where("register_name = '#{params[:register]}' AND statuses.status = 'pending'")
    @register = get_register(params[:register])

    if @changes.any? { |c| c.payload.value?(params[:id])}
      flash[:notice] = 'There is already a pending update on this record, this must be reviewed before creating another update'
      redirect_to registers_path
    end

    @form = convert_register_json(
        OpenRegister.record(params[:register].downcase, params[:id], Rails.configuration.register_phase)
    ) if @form.nil?
  end

  def confirm
    register_name = params[:register].downcase
    field_definitions = @registers_client.get_register(register_name, 'beta').get_field_definitions
    records = @registers_client.get_register(register_name, 'beta').get_records
    validation_result = @data_validator.get_form_errors(params, field_definitions, register_name, records)
    if validation_result.messages.present?
      validation_result.messages.each { |k,v| flash.now[k] = v.join(', ') }
      @register = get_register(register_name)
      @form = JSON.parse(params.to_json)
      render :new
    else
      return true if params[:data_confirmed]
      @register = get_register(register_name)
      @current_register_record = OpenRegister.record(register_name,
                          params[register_name.to_sym],
                          Rails.configuration.register_phase)

      if @current_register_record
        @current_register_record = convert_register_json(@current_register_record)
      end

      render :confirm
    end
  end

  def create
    fields = get_register(params[:register]).fields

    payload = generate_canonical_object(fields, params)

    if current_user.basic?
      @change = Change.new(register_name: params[:register], payload: payload, user_id: current_user.id)
      @change.status = Status.new(status: 'pending')
      @change.save

      @change_approvers = Register.find_by(key: params[:register]).team.team_members.where.not(role: 'basic', user_id: current_user)

      if @change_approvers.present?
        RegisterUpdatesMailer.register_update_notification(@change, current_user, @change_approvers).deliver_now
      end

      RegisterUpdatesMailer.register_update_receipt(@change, current_user).deliver_now

      flash[:notice] = 'Your update has been submitted and sent for review.'
      redirect_to action: 'index', register: params[:register]
    else
      if params[:confirm_approve] == '1'
        @change = Change.new(register_name: params[:register], payload: payload, user_id: current_user.id)
        @change.status = Status.new(status: 'approved', reviewed_by_id: current_user.id)
        @change.save

        rsf_body = CreateRsf.(@change.payload, @change.register_name)
        Rails.env.development? || response = RegisterPost.(@change.register_name, rsf_body)

        if Rails.env.development? || Rails.env.staging? || response.code == '200'
          @registers_client.get_register(@change.register_name, Rails.configuration.register_phase.to_s).refresh_data
          flash[:notice] = 'The record has been published.'
          redirect_to controller: 'register', action: 'index', register: params[:register]
        else
          flash[:alert] = 'We had an issue updating the register, try again.'
        end
      else
        register_name = params[:register].downcase
        @register = get_register(params[:register])
        @current_register_record = OpenRegister.record(register_name, params[register_name.to_sym], :beta)

        if @current_register_record
          @current_register_record = convert_register_json(@current_register_record)
        end
        flash[:alert] = "Please confirm that you wish for this update to be published on the live #{register_name} register."
        render :confirm
      end
    end
  end

  private

  def initialize_controller
    @data_validator = ValidationHelper::DataValidator.new
    @registers_client = OpenRegister::RegistersClient.new
  end
end