class TeamsPolicy

  def self.view?(current_user, team_id)
    return false unless values_present? current_user, team_id

    return true if current_user.admin?

    member? current_user, team_id
  end

  def update?(current_user, team_id)
    return false unless values_present? current_user, team_id

    return true if current_user.admin?

    return false unless member? current_user, team_id

    current_user.custodian? || current_user.advanced?
  end

  private

  def self.values_present?(current_user, team_id)
    current_user.present? && team_id.present?
  end

  def self.member?(current_user, team_id)
    current_user.teams.each { |team|
      return true if team.id == team_id
    }

    false
  end
end