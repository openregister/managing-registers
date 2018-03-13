class HomeController < ApplicationController
  include ApplicationHelper
  include RegisterHelper

  def index
    register_data = @registers_client.get_register('register', Rails.configuration.register_phase, nil)

    @registers = register_data.get_records
                              .select { |record| select? record.entry }
                              .sort_by { |record| record.entry.key }
  end

  def select?(item)
    not_system_register(item) && has_permissions(item, current_user)
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
