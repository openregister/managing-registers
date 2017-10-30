class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register', Rails.configuration.register_phase)
                   ._all_records
                   .select { |item| select? item }
                   .sort_by(&:key)
  end

  def select?(item)
    %w{register datatype field}.any? { |type| type == format(item.key) }
  end

  def format(key)
    key.to_s.downcase
  end
end