class TeamMember < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :team, optional: true

  accepts_nested_attributes_for :user

end
