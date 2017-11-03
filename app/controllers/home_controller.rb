class HomeController < ApplicationController
  include ApplicationHelper

  def index
    @registers = OpenRegister.register('register', Rails.configuration.register_phase)
                   ._all_records
                   .select { |item| select? item }
                   .sort_by(&:key)
  end

  def select?(item)
    not_system_register(item) && has_permissions(item, current_user)
  end

  def not_system_register(item)
    %w{register datatype field}.none? { |type| type == format(item.key) }
  end

  def has_permissions(item, current_user)
    return true if current_user.admin?

    register = Register.find_by(key: item.key)

    return false if register.nil?

    register.team.team_members.each { |team_member|
      return true if team_member.id == current_user.id
    }

    false
  end

  def format(key)
    key.to_s.downcase
  end
end