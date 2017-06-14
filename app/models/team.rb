class Team < ApplicationRecord
  has_many :team_members
  has_many :users, through: :team_members

  def custodian
    team_members.where(role: 'custodian').first.user
  end
end
