class RegisterPolicy < Policy

  class << self

    def create_and_review?(current_user, register_name)
      return false unless values_present? current_user, register_name

      return true if current_user.admin?

      return false unless associated? current_user, register_name

      Responsibility.manager?(current_user)
    end

    def create_pending_review?(current_user, register_name)
      allowed?(current_user, register_name)
    end

    def confirm?(current_user, register_name)
      allowed?(current_user, register_name)
    end

    def new?(current_user, register_name)
      allowed?(current_user, register_name)
    end

    def view?(current_user, register_name)
      allowed?(current_user, register_name)
    end

    def update?(current_user, register_name)
      allowed?(current_user, register_name)
    end

    private

    def allowed?(current_user, register_name)
      return false unless values_present? current_user, register_name

      return true if current_user.admin?

      return false unless associated? current_user, register_name

      Responsibility.user?(current_user)
    end

    def associated?(current_user, register_name)
      register = Register.find_by(key: register_name)

      return false if register.nil?

      register.team.team_members.each { |team_member|
        return true if team_member.id == current_user.id
      }

      false
    end
  end
end

