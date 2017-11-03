class HomeController < ApplicationController
  include ApplicationHelper

  def index
    raise PermissionError unless "#{controller_name.humanize.singularize}Policy".constantize.view? current_user

    @registers = OpenRegister.register('register', Rails.configuration.register_phase)
                   ._all_records
                   .select { |item| select? item }
                   .sort_by(&:key)
  end

  def select?(item)
    %w{register datatype field}.none? { |type| type == format(item.key) }
  end

  def format(key)
    key.to_s.downcase
  end
end