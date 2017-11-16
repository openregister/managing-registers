class TeamsPolicy < Policy
  class << self
    def show?(current_user, team_id)
      return false unless values_present? current_user, team_id

      return true if current_user.admin?

      return false unless member? current_user, team_id

      Responsibility.user?(current_user)
    end

    def index?(current_user)
      return false unless current_user.present?

      current_user.admin? || Responsibility.user?(current_user)
    end

    def update?(current_user, team_id)
      return false unless values_present? current_user, team_id

      return true if current_user.admin?

      return false unless member? current_user, team_id

      Responsibility.manager?(current_user)
    end

    def edit?(current_user, team_id)
      return false unless values_present? current_user, team_id

      return true if current_user.admin?

      return false unless member? current_user, team_id

      Responsibility.manager?(current_user)
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
