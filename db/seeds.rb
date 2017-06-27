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
user2 = User.create(
  email: 'tony.worron@fco.gsi.gov.uk',
  full_name: 'Tony Worron',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: user1
)
user3 = User.create(
  email: 'stephen.mcallister@communities.gsi.gov.uk',
  full_name: 'Stephen McAllister',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: user1
)
user4 = User.create(
  email: 'jane.bloggs@gds.gov.uk',
  full_name: 'Jane Bloggs',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: user1
)
user5 = User.create(
  email: 'joe.bloggs@gds.gov.uk',
  full_name: 'Joe Bloggs',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: user1
)
user6 = User.create(
  email: 'jeremy.bloggs@gds.gov.uk',
  full_name: 'Jeremy Bloggs',
  password: 'password123',
  password_confirmation: 'password123',
  invitation_accepted_at: Date.today,
  invited_by: user1
)

team1 = Team.create
team2 = Team.create

TeamMember.create(role: 'admin', user: user1)
TeamMember.create(role: 'custodian', user: user2, team: team1)
TeamMember.create(role: 'custodian', user: user3, team: team2)
TeamMember.create(role: 'advanced', user: user4, team: team1)
TeamMember.create(role: 'advanced', user: user4, team: team2)
TeamMember.create(role: 'basic', user: user5, team: team1)
TeamMember.create(role: 'basic', user: user5, team: team2)
TeamMember.create(role: 'basic', user: user6, team: team2)
TeamMember.create(role: 'basic', user: user2, team: team2)

Register.create(key: 'country', team: team1)
Register.create(key: 'territory', team: team1)
Register.create(key: 'local-authority-eng', team: team2)
Register.create(key: 'local-authority-type', team: team2)

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
  user: user2
)
