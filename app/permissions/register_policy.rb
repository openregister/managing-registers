class RegisterPolicy < Policy
  class << self
    def create_and_review?(current_user, register_name)
      unless values_present? current_user, register_name
        log "RegisterPolicy::#{__method__}: Not enough values to check."
        return false
      end

      return true if current_user.admin?

      unless associated? current_user, register_name
        log "RegisterPolicy::#{__method__}: The user #{current_user.id} is not associated with the register #{register_name}."
        return false
      end

      if Responsibility.manager?(current_user)
        true
      else
        log "RegisterPolicy::#{__method__}: The user #{current_user.id} cannot manage the register."
        false
      end
    end

    def create_pending_review?(current_user, register_name)
      allowed?(current_user, register_name, __method__)
    end

    def confirm?(current_user, register_name)
      allowed?(current_user, register_name, __method__)
    end

    def new?(current_user, register_name)
      allowed?(current_user, register_name, __method__)
    end

    def view?(current_user, register_name)
      allowed?(current_user, register_name, __method__)
    end

    def update?(current_user, register_name)
      allowed?(current_user, register_name, __method__)
    end

  private

    def allowed?(current_user, register_name, method_name)
      unless values_present? current_user, register_name
        log "RegisterPolicy::#{method_name}: Not enough values to check."
        return false
      end

      return true if current_user.admin?

      unless associated? current_user, register_name
        log "RegisterPolicy::#{method_name}: The user #{current_user.id} is not associated with the register #{register_name}."
        return false
      end

      if Responsibility.user?(current_user)
        true
      else
        log "RegisterPolicy::#{method_name}: The user #{current_user.id} cannot managee the register."
        false
      end
    end

    def associated?(current_user, register_name)
      register = Register.find_by(key: register_name)

      return false if register.nil?

      register.team.team_members.each { |team_member|
        return true if team_member.user_id.to_s == current_user.id.to_s
      }

      false
    end
  end
end
