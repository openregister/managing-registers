class ChangeController < ApplicationController

  include ApplicationHelper

  def show
    @change = Change.find(params['id'])
    @register = get_register(@change.register_name)
    @new_register_record = @change.payload
    @current_register_record = OpenRegister.record(@change.register_name,
                                                   @change.payload[@change.register_name],
                                                   :beta)
    if @current_register_record != nil
      @current_register_record = convert_register_json(@current_register_record)
    end
  end

  def edit
    if params[:approve] == 'yes'
      @change = Change.find(params['id'])
      @register = get_register(@change.register_name)
      @new_register_record = @change.payload
      @current_register_record = OpenRegister.record(@change.register_name,
                                                     @change.payload[@change.register_name],
                                                     :beta)
      if @current_register_record != nil
        @current_register_record = convert_register_json(@current_register_record)
      end
    else
      @change_user = Change.find(params['id']).user
    end
  end

  def destroy
    @change = Change.find(params['id'])
    @change.status.update_attributes(status: 'rejected', comment: params[:comments], reviewed_by_id: current_user.id)
    @change.save

    RegisterUpdatesMailer.register_update_rejected(@change, current_user).deliver_now

    flash[:notice] = 'An email has been sent to the user.'
    redirect_to controller: 'register', action: 'index', register: Change.find(params['id']).register_name
  end

  def update
    if params[:confirm_approve] == '1'
      @change = Change.find(params['id'])

      rsf_body = CreateRsf.new(@change.payload, @change.register_name).call

      Rails.env.development? || Rails.env.staging? || response = RegisterPost.new(@change.register_name, rsf_body).call

      if Rails.env.development? || Rails.env.staging? || response.code == '200'
        @change.status.update_attributes(status: 'approved', reviewed_by_id: current_user.id)
        @change.save

        flash[:notice] = 'The record has been published.'
      else
        flash[:alert] = 'We had an issue updating the register, try again.'
      end

      RegisterUpdatesMailer.register_update_approved(@change, current_user).deliver_now

      redirect_to controller: 'register', action: 'index', register: Change.find(params['id']).register_name
    else
      flash[:notice] = 'Please confirm that you wish to approve this update'
      redirect_to :back
    end
  end
end
