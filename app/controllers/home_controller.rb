class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register', Rails.configuration.register_phase)._all_records
  end
end