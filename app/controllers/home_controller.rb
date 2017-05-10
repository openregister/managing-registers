class HomeController < ApplicationController

  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register', Rails.configuration.register_phase)._all_records.sort_by{|register| register.key}
  end

  def select_register
    redirect_to controller: 'register', action: 'index', register: params[:register]
  end

end
