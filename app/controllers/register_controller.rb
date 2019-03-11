# frozen_string_literal: true

class RegisterController < ApplicationController
  include RegisterHelper
  include ApplicationHelper

  before_action :initialize_controller, only: [:create]
  before_action :confirm, only: [:create]

  def index
    check_permissions(:REGISTER_INDEX, current_user: current_user,
                                      register_name: params[:register_id])

    @changes = Change.joins('LEFT OUTER JOIN statuses on statuses.change_id = changes.id')
                     .where("register_name = '#{params[:register_id]}' AND statuses.status = 'pending'")

    @register = @registers_client.get_register(params[:register_id], Rails.configuration.register_phase)
                .get_records
                .sort_by { |record| record.entry.key }
  end

  def new
    check_permissions(:REGISTER_NEW, current_user: current_user,
                                    register_name: params[:register_id])

    @register = @registers_client.get_register(params[:register_id], Rails.configuration.register_phase)
    @form = JSON.parse(params.to_json)
  end

  def edit
    check_permissions(:REGISTER_EDIT, current_user: current_user,
                                     register_name: params[:register_id])
    @changes = Change.joins('LEFT OUTER JOIN statuses on statuses.change_id = changes.id')
                     .where("register_name = '#{params[:register_id]}' AND statuses.status = 'pending'")
    @register = @registers_client.get_register(params[:register_id], Rails.configuration.register_phase)

    if @changes.any? { |c| c.payload.value?(params[:id]) }
      flash[:notice] = 'There is already a pending update on this record, this must be reviewed before creating another update'
      redirect_to registers_path
    end

    if @form.nil?
      register_data = @registers_client.get_register(params[:register_id], Rails.configuration.register_phase)
      @record = register_data.get_record(params[:id])
      @form = convert_register_json(@record)
    end
  end

  def confirm
    check_permissions(:REGISTER_CONFIRM, current_user: current_user,
                                        register_name: params[:register_id])

    register_name = params[:register_id].downcase
    field_definitions = @registers_client.get_register(register_name, 'beta').get_field_definitions
    records = @registers_client.get_register(register_name, 'beta').get_records
    validation_result = @data_validator.get_form_errors(params, field_definitions, register_name, records, @registers_client)
    if validation_result.messages.present?
      validation_result.messages.each { |k, v| flash.now[k] = v.join(', ') }
      @register = @registers_client.get_register(register_name, Rails.configuration.register_phase)
      @form = JSON.parse(params.to_json)
      render :new
    else
      return true if params[:data_confirmed]

      @register = @registers_client.get_register(register_name, Rails.configuration.register_phase)
      @current_register_record = @register.get_record(params[register_name.to_sym])

      if @current_register_record
        @current_register_record = convert_register_json(@current_register_record)
      end
      render :confirm
    end
  end

  def create
    fields = @registers_client.get_register(params[:register_id], Rails.configuration.register_phase).get_register_definition.item.value['fields']
    payload = generate_canonical_object(fields, params)

    if current_user.basic?
      create_pending_review payload
    else
      create_and_review payload
    end
  end

private

  def create_pending_review(payload)
    check_permissions(:REGISTER_CREATE_PENDING_REVIEW, current_user: current_user,
                                                      register_name: params[:register_id])

    @change = Change.new(register_name: params[:register_id], payload: payload, user_id: current_user.id)
    @change.status = Status.new(status: 'pending')
    @change.save

    @change_approvers = Register.find_by(key: params[:register_id]).team.team_members.where.not(role: 'basic', user_id: current_user)

    if @change_approvers.present?
      RegisterUpdatesMailer.register_update_notification(@change, current_user, @change_approvers).deliver_now
    end

    RegisterUpdatesMailer.register_update_receipt(@change, current_user).deliver_now

    flash[:notice] = 'Your update has been submitted and sent for review.'
    redirect_to action: 'index', register: params[:register_id]
  end

  def create_and_review(payload)
    check_permissions(:REGISTER_CREATE_AND_REVIEW, current_user: current_user,
                                                  register_name: params[:register_id])

    if params[:confirm_approve] == '1'
      @change = Change.new(register_name: params[:register_id], payload: payload, user_id: current_user.id)
      @change.status = Status.new(status: 'approved', reviewed_by_id: current_user.id)
      @change.save

      rsf_body = CreateRsf.call(@change.payload, @change.register_name)
      Rails.env.development? || response = RegisterPost.call(@change.register_name, rsf_body)

      if Rails.env.development? || response.code == '200'
        @registers_client.get_register(@change.register_name, Rails.configuration.register_phase.to_s).refresh_data
        flash[:notice] = 'The record has been published.'
        redirect_to controller: 'register', action: 'index', register: params[:register_id]
      else
        flash[:alert] = 'This update hasn’t been published due to technical reasons. Please try again.'
        redirect_back fallback_location: root_path
      end
    else
      register_name = params[:register_id].downcase
      @register = get_register(params[:register_id])
      @current_register_record = OpenRegister.record(register_name, params[register_name.to_sym], :beta)

      if @current_register_record
        @current_register_record = convert_register_json(@current_register_record)
      end
      flash.now[:confirm_approve] = "Please confirm that this update is ready to be published to the #{register_name.capitalize} register."
      render :confirm
    end
  end

  def initialize_controller
    @data_validator = ValidationHelper::DataValidator.new
  end
end
