class TeamMembersPolicy

  def self.edit?(current_user, team_id, team_member_id)
    modify? current_user, team_id, team_member_id
  end

  def self.update?(current_user, team_id, team_member_id)
    modify? current_user, team_id, team_member_id
  end

  def self.destroy?(current_user, team_id, team_member_id)
    modify? current_user, team_id, team_member_id
  end

  private

  def self.values_present?(current_user, team_id, team_member_id)
    current_user.present? && team_id.present? && team_member_id.present?
  end

  def self.modify?(current_user, team_id, team_member_id)
    return false unless values_present? current_user, team_id, team_member_id

    return true if current_user.admin?

    return false unless same_team? current_user, team_id, team_member_id

    current_user.custodian? || current_user.advanced?
  end

  def self.same_team?(current_user, team_id, team_member_id)
    team_member = TeamMember.find_by_id(team_member_id)

    (member? current_user, team_id) && (team_member? team_member, team_id)
  end

  def self.member?(user, team_id)
    user.teams.each { |team|
      return true if team.id == team_id
    }

    false
  end

  def self.team_member?(team_member, team_id)
    team_member.team_id == team_id
  end
end