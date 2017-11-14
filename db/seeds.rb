Change.destroy_all
Register.destroy_all
TeamMember.destroy_all
Team.destroy_all
User.destroy_all

user1 = User.create(
  email: 'admin@gov.uk',
  full_name: 'Admin',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  admin: true
)

admin_user = User.create(
  email: 'admin@example.org',
  full_name: 'Admin',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  admin: true
)
custodian_team1_user = User.create(
  email: 'custodian.team1@example.org',
  full_name: 'Custodian (team 1)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
custodian_team2_user = User.create(
  email: 'custodian.team2@example.org',
  full_name: 'Custodian (team 2)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
custodian_both_user = User.create(
  email: 'custodian.both@example.org',
  full_name: 'Custodian (both)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
advanced_team1_user = User.create(
  email: 'advanced.team1@example.org',
  full_name: 'Advanced (team 1)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
advanced_team2_user = User.create(
  email: 'advanced.team2@example.org',
  full_name: 'Advanced (team 2)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
advanced_both_user = User.create(
  email: 'advanced.both@example.org',
  full_name: 'Advanced (both)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
basic_team1_user = User.create(
  email: 'basic.team1@example.org',
  full_name: 'Basic (team 1)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
basic_team2_user = User.create(
  email: 'basic.team2@example.org',
  full_name: 'Basic (team 2)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)
basic_both_user = User.create(
  email: 'basic.both@example.org',
  full_name: 'Basic (both)',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: admin_user
)

team1 = Team.create
team2 = Team.create

TeamMember.create(role: 'admin', user: user1)
TeamMember.create(role: 'admin', user: admin_user)
TeamMember.create(role: 'custodian', user: custodian_team1_user, team: team1)
TeamMember.create(role: 'custodian', user: custodian_team2_user, team: team2)
TeamMember.create(role: 'custodian', user: custodian_both_user, team: team1)
TeamMember.create(role: 'custodian', user: custodian_both_user, team: team2)
TeamMember.create(role: 'advanced', user: advanced_team1_user, team: team1)
TeamMember.create(role: 'advanced', user: advanced_team2_user, team: team2)
TeamMember.create(role: 'advanced', user: advanced_both_user, team: team1)
TeamMember.create(role: 'advanced', user: advanced_both_user, team: team2)
TeamMember.create(role: 'basic', user: basic_team1_user, team: team1)
TeamMember.create(role: 'basic', user: basic_team2_user, team: team2)
TeamMember.create(role: 'basic', user: basic_both_user, team: team1)
TeamMember.create(role: 'basic', user: basic_both_user, team: team2)

Register.create(key: 'country', team: team1)
Register.create(key: 'address', team: team2)

Change.create(
  register_name: 'country',
  payload: JSON.parse('
    {
      "citizen-names":"Afghan",
      "country":"AF",
      "name":"Afghanistan",
      "official-name":"The Islamic Republic of Afghanistan",
      "start-date":"asd"
    }
  '),
  user: custodian_team1_user
)
