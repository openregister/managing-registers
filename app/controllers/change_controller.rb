class ChangeController < ApplicationController

  include ApplicationHelper

  def show
    @change = Change.find(params['id'])
    @register = get_register(@change.register_name)
    @new_register_record = @change.payload
    @current_register_record = OpenRegister.record(@change.register_name,
                                                   @change.payload[@change.register_name],
                                                   @register_phase)
    if @current_register_record != nil
      @current_register_record = convert_register_json(@current_register_record)
    end
  end

  def edit
    puts "hello"
    if params[:approve] == 'yes'
      @change = Change.find(params['id'])
      @register = get_register(@change.register_name)
      @new_register_record = @change.payload
      @current_register_record = OpenRegister.record(@change.register_name,
                                                     @change.payload[@change.register_name],
                                                     @register_phase)
      if @current_register_record != nil
        @current_register_record = convert_register_json(@current_register_record)
      end
    else
      @change_user = Change.find(params['id']).user
    end
  end

  def destroy

  end

  def update

  end

end