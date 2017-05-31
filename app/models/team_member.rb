class TeamMember < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :team, optional: true

end
