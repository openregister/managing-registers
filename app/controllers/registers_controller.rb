class RegistersController < ApplicationController
  include ApplicationHelper
  helper_method :prepare_register_name

  def index
    @registers = OpenRegister.register('register', :beta)._all_records.sort_by{|register| register.key}
  end

  def select_register
    redirect_to controller: 'register', action: 'index', register: params[:register]
  end

end
