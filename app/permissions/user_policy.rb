class UserPolicy < Policy
  class << self
    def show?(current_user, user)
      return false unless values_present? current_user, user

      current_user.id == user.id
    end

    def custodians?(current_user)
      permission?(current_user)
    end

    def new?(current_user, role, team_id)
      return false unless values_present? current_user

      return role.present? if current_user.admin?

      if team_id.present?
        unless member?(current_user, team_id)
          return false
        end
      else
        return false
      end

      Responsibility.manager?(current_user)
    end

    def create?(current_user)
      return false unless values_present? current_user

      current_user.admin? || Responsibility.manager?(current_user)
    end

    def admin?(current_user)
      permission?(current_user)
    end

    def destroy?(current_user)
      permission?(current_user)
    end

  private

    def permission?(current_user)
      return false unless values_present? current_user

      current_user.admin?
    end

    def member?(current_user, team_id)
      current_user.teams.each { |team|
        return true if team.id.to_s == team_id.to_s
      }

      false
    end
  end
end
