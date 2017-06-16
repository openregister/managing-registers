class HomeController < ApplicationController

  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register',
                                       Rails.configuration.register_phase)
                             ._all_records.sort_by(&:key)
  end

end