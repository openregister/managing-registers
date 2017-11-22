class UserPolicy < Policy
  class << self
    def show?(current_user, user)
      unless values_present? current_user, user
        log "UserPolicy::#{__method__}: Not enough values to check."
        return false
      end

      if current_user.id == user.id
        true
      else
        log "UserPolicy::#{__method__}: Users does not match #{current_user.id} != #{user.id}"
        false
      end
    end

    def custodians?(current_user)
      permission?(current_user, 'custodians?')
    end

    def new?(current_user, role, team_id)
      unless values_present? current_user
        log "UserPolicy::#{__method__}: Not enough values to check."
        return false
      end

      if current_user.admin?
        if role.present?
          return true
        else
          log "UserPolicy::#{__method__}: Role not present."
          return false
        end
      end

      if team_id.present?
        unless member?(current_user, team_id)
          log "UserPolicy::#{__method__}: The user #{current_user.id} is not a member of the team #{team_id}."
          return false
        end
      else
        log 'UserPolicy::new?: Team ID not present.'
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "UserPolicy::#{__method__}: The user #{current_user.id} cannot manage the team #{team_id}."
        false
      end
    end

    def create?(current_user)
      unless values_present? current_user
        log "UserPolicy::#{__method__}: Not enough values to check."
        return false
      end

      if current_user.admin? || Responsibility.manager?(current_user)
        true
      else
        log "UserPolicy::#{__method__}: The user #{current_user.id} does not have permissions."
        false
      end
    end

    def admin?(current_user)
      permission?(current_user, 'admin?')
    end

    def destroy?(current_user)
      permission?(current_user, 'destroy?')
    end

  private

    def permission?(current_user, method_name)
      unless values_present? current_user
        log "UserPolicy::#{method_name}: Not enough values to check."
        return false
      end

      if current_user.admin?
        true
      else
        log "UserPolicy::#{method_name}: Not enough permission."
        false
      end
    end

    def member?(current_user, team_id)
      current_user.teams.each { |team|
        return true if team.id.to_s == team_id.to_s
      }

      false
    end
  end
end
