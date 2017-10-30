class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register', Rails.configuration.register_phase)
                   ._all_records
                   .select { |item| select? item }
                   .sort_by(&:key)
  end

  def select?(item)
    !(format(item.key) == 'register' || format(item.key) == 'datatype' || format(item.key) == 'field')
  end

  def format(key)
    key.to_s.downcase
  end
end