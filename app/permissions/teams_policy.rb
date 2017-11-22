class TeamsPolicy < Policy
  class << self
    def show?(current_user, team_id)
      unless values_present? current_user, team_id
        log "TeamsPolicy::#{__method__}: Not enough values to check."
        return false
      end

      return true if current_user.admin?

      unless member? current_user, team_id
        log "TeamsPolicy::#{__method__}: The user #{current_user.id} is not a member of the team #{team_id}."
        return false
      end

      if Responsibility.user?(current_user)
        true
      else
        log "TeamsPolicy::#{__method__}: The user #{current_user} in not a user of the team #{team_id}."
        false
      end
    end

    def index?(current_user)
      unless current_user.present?
        log 'TeamsPolicy::index?: Not enough values to check.'
        return false
      end

      if current_user.admin? || Responsibility.user?(current_user)
        true
      else
        log "TeamsPolicy::#{__method__}: The user #{current_user} does not have permissions."
        false
      end
    end

    def update?(current_user, team_id)
      unless values_present? current_user, team_id
        log 'TeamsPolicy::update?: Not enough values to check.'
        return false
      end

      return true if current_user.admin?

      unless member? current_user, team_id
        log "TeamsPolicy::#{__method__}: The user #{current_user.id} is not a member of the team #{team_id}."
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "TeamsPolicy::#{__method__}: The user #{current_user} cannot manage the team #{team_id}."
        false
      end
    end

    def edit?(current_user, team_id)
      unless values_present? current_user, team_id
        log "TeamsPolicy::#{__method__}: Not enough values to check."
        return false
      end

      return true if current_user.admin?

      unless member? current_user, team_id
        log "TeamsPolicy::#{__method__}: The user #{current_user.id} is not a member of the team #{team_id}."
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "TeamsPolicy::#{__method__}: The user #{current_user} cannot manage the team #{team_id}."
        false
      end
    end

  private

    def member?(current_user, team_id)
      current_user.teams.each { |team|
        return true if team.id.to_s == team_id.to_s
      }

      false
    end
  end
end
