TeamMember.destroy_all
Team.destroy_all
User.destroy_all
Change.destroy_all

User.create(email: 'admin@gov.uk', password: 'password123', full_name: 'Admin', password_confirmation: 'password123', invitation_accepted_at: Date.today)
User.create(email: 'tony.worron@fco.gsi.gov.uk', full_name: 'Tony Worron', password: 'password123', password_confirmation: 'password123', invitation_accepted_at: Date.today)
User.create(email: 'stephen.mcallister@communities.gsi.gov.uk', full_name: 'Stephen McAllister', password: 'password123', password_confirmation: 'password123', invitation_accepted_at: Date.today)
User.create(email: 'jane.bloggs@gds.gov.uk', full_name: 'Jane Bloggs', password: 'password123', password_confirmation: 'password123', invitation_accepted_at: Date.today)
User.create(email: 'joe.bloggs@gds.gov.uk', full_name: 'Joe Bloggs', password: 'password123', password_confirmation: 'password123', invitation_accepted_at: Date.today)
User.create(email: 'jeremy.bloggs@gds.gov.uk', full_name: 'Jeremy Bloggs', password: 'password123', password_confirmation: 'password123', invitation_accepted_at: Date.today)

Team.create(registers:  ['country', 'territory'])
Team.create(registers:  ['local-authority-eng', 'local-authority-type'])

TeamMember.create(role: 'admin', user_id: 1)
TeamMember.create(role: 'custodian', user_id: 2, team_id: 1)
TeamMember.create(role: 'custodian', user_id: 3, team_id: 2)
TeamMember.create(role: 'advanced', user_id: 4, team_id: 1)
TeamMember.create(role: 'advanced', user_id: 4, team_id: 2)
TeamMember.create(role: 'basic', user_id: 5, team_id: 1)
TeamMember.create(role: 'basic', user_id: 5, team_id: 2)
TeamMember.create(role: 'basic', user_id: 6, team_id: 2)
TeamMember.create(role: 'basic', user_id: 2, team_id: 2)


Change.create(
  register_name: 'country',
  payload: JSON.parse('{"citizen-names":"Afghan","country":"AF","name":"Afghanistan","official-name":"The Islamic Republic of Afghanistan","start-date":"asd"}'),
  user_id: 2
)

