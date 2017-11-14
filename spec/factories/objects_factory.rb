class ObjectsFactory
  include FactoryBot::Syntax::Methods

  def create_user_only(email, admin)
    create(:user, email: email, admin: admin)
  end

  def create_team_only
    create(:team)
  end

  def create_user_with_team(email, admin, role)
    user = create(:user, email: email, admin: admin)
    team = create(:team)
    create(:team_member, user: user, team: team, role: role)

    User.find_by_email(email)
  end

  def create_register(email, admin, role, register_key)
    user = create(:user, email: email, admin: admin)
    team = create(:team)
    create(:team_member, user: user, team: team, role: role)
    create(:register, key: register_key, team: team)
  end
end