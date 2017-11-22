class TeamMembersPolicy < Policy
  class << self
    def edit?(current_user, team_id, team_member_id)
      unless values_present? current_user, team_id, team_member_id
        log "TeamMembersPolicy::#{__method__}: Not enough values to check."
        return false
      end

      return true if current_user.admin?

      unless same_team_with_id? current_user, team_id, team_member_id
        log "TeamMembersPolicy::#{__method__}: User #{current_user.id} and team member #{team_member_id} are not in the same team #{team_id}."
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "TeamMembersPolicy::#{__method__}: The user #{current_user} cannot manage team members."
        false
      end
    end

    def update?(current_user, team_member_id)
      unless values_present? current_user, team_member_id
        log 'TeamMembersPolicy::update?] Not enough values to check.'
        return false
      end

      return true if current_user.admin?

      unless same_team? current_user, team_member_id
        log "TeamMembersPolicy::#{__method__}: User #{current_user.id} and team member #{team_member_id} are not in the same team."
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "TeamMembersPolicy::#{__method__}: The user #{current_user} cannot manage team members."
        false
      end
    end

    def destroy?(current_user, team_member_id)
      unless values_present? current_user, team_member_id
        log "TeamMembersPolicy::#{__method__}: Not enough values to check."
        return false
      end

      return true if current_user.admin?

      unless same_team? current_user, team_member_id
        log "TeamMembersPolicy::#{__method__}: User #{current_user.id} and team member #{team_member_id} are not in the same team."
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "TeamMembersPolicy::#{__method__}: The user #{current_user} cannot manage team members."
        false
      end
    end

  private

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
