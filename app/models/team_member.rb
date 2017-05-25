class TeamMember < ApplicationRecord

  devise :database_authenticatable, :confirmable, :invitable

  belongs_to :user
  belongs_to :team
end
