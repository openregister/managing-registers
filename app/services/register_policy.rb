class RegisterPolicy

  def self.create?(current_user, register_name)
    return false unless values_present? current_user, register_name

    return true if current_user.admin?

    return false unless associated? current_user, register_name

    current_user.custodian? || current_user.advanced?
  end

  def self.view?(current_user, register_name)
    return false unless values_present? current_user, register_name

    return true if current_user.admin?

    associated? current_user, register_name
  end

  def update?(current_user, register_name)
    return false unless values_present? current_user, register_name

    return true if current_user.admin?

    return false unless associated? current_user, register_name

    current_user.custodian? || current_user.advanced? || current_user.basic?
  end

  private

  def self.values_present?(current_user, register_name)
    current_user.present? && register_name.present?
  end

  def self.associated?(current_user, register_name)
    Register.find_by(key: register_name).team.team_members.each { |team_member|
      return true if team_member.id == current_user.id
    }

    false
  end

end