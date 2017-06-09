class ChangeController < ApplicationController

  include ApplicationHelper

  def index
    @change = Change.find(params['change_id'])
    @register = get_register(@change.register_name)
    @new_register_record = @change.payload
    @current_register_record = OpenRegister.record(@change.register_name,
                                                   @change.payload[@change.register_name],
                                                   @register_phase)
    if @current_register_record != nil
      @current_register_record = convert_register_json(@current_register_record)
    end

    puts "hi"
  end

  def edit

  end

end