# frozen_string_literal: true

class ChangeController < ApplicationController
  include ApplicationHelper

  def show
    @change = Change.find(params['id'])

    check_permissions(:CHANGE_SHOW, current_user: current_user,
                                   register_name: @change.register_name)

    @register = @registers_client.get_register(@change.register_name, Rails.configuration.register_phase)
    @new_register_record = @change.payload
    @current_register_record = @register.get_record(@change.payload[@change.register_name])
    unless @current_register_record.nil?
      @current_register_record = convert_register_json(@current_register_record)
    end
  end

  def edit
    if params[:approve] == 'yes'
      @change = Change.find(params['id'])

      check_permissions(:CHANGE_EDIT, current_user: current_user,
                                     register_name: @change.register_name)

      @register = @registers_client.get_register(@change.register_name, Rails.configuration.register_phase)
      @new_register_record = @change.payload
      @current_register_record = @register.get_record(@change.payload[@change.register_name])
      unless @current_register_record.nil?
        @current_register_record = convert_register_json(@current_register_record)
      end
    else
      @change_user = Change.find(params['id']).user
    end
  end

  def destroy
    @change = Change.find(params['id'])

    check_permissions(:CHANGE_DESTROY, current_user: current_user,
                                      register_name: @change.register_name)

    @change.status.update_attributes(status: 'rejected', comment: params[:comments], reviewed_by_id: current_user.id)
    @change.save

    RegisterUpdatesMailer.register_update_rejected(@change, current_user).deliver_now

    flash[:notice] = 'An email has been sent to the user.'
    redirect_to controller: 'register', action: 'index', register_id: Change.find(params['id']).register_name
  end

  def update
    if params[:confirm_approve] == '1'
      @change = Change.find(params['id'])

      check_permissions(:CHANGE_UPDATE, current_user: current_user,
                                       register_name: @change.register_name)

      rsf_body = CreateRsf.call(@change.payload, @change.register_name)

      Rails.env.development? || response = RegisterPost.call(@change.register_name, rsf_body)

      if Rails.env.development? || response.code == '200'
        @change.status.update_attributes(status: 'approved', reviewed_by_id: current_user.id)
        @change.save

        flash[:notice] = 'The record has been published.'
      else
        flash[:alert] = 'This update hasn’t been approved due to technical reasons. Please try again.'
      end

      RegisterUpdatesMailer.register_update_approved(@change, current_user).deliver_now

      redirect_to controller: 'register', action: 'index', register_id: Change.find(params['id']).register_name
    else
      flash[:notice] = 'Please confirm that you wish to approve this update'
      redirect_to :back
    end
  end
end
