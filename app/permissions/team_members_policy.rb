class TeamMembersPolicy < Policy
  class << self
    def edit?(current_user, team_id, team_member_id)
      modify? current_user, team_id, team_member_id
    end

    def update?(current_user, team_member_id)
      return false unless values_present? current_user, team_member_id

      return true if current_user.admin?

      return false unless same_team? current_user, team_member_id

      Responsibility.manager?(current_user)
    end

    def destroy?(current_user, team_member_id)
      return false unless values_present? current_user, team_member_id

      return true if current_user.admin?

      return false unless same_team? current_user, team_member_id

      Responsibility.manager?(current_user)
    end

  private

    def modify?(current_user, team_id, team_member_id)
      return false unless values_present? current_user, team_id, team_member_id

      return true if current_user.admin?

      return false unless same_team_with_id? current_user, team_id, team_member_id

      Responsibility.manager?(current_user)
    end

    def same_team?(current_user, team_member_id)
      team_member = TeamMember.find_by_id(team_member_id)

      return false if team_member.nil?

      member?(current_user, team_member.team_id)
    end

    def same_team_with_id?(current_user, team_id, team_member_id)
      team_member = TeamMember.find_by_id(team_member_id)

      return false if team_member.nil?

      (member? current_user, team_id) && (team_member? team_member, team_id)
    end

    def member?(user, team_id)
      user.teams.each { |team|
        return true if team.id.to_s == team_id.to_s
      }

      false
    end

    def team_member?(team_member, team_id)
      team_member.team_id.to_s == team_id.to_s
    end
  end
end
