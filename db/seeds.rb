User.destroy_all
User.create(email: "admin@gov.uk", password: "password123", full_name: "Admin", password_confirmation: "password123", role: "admin")
User.create(email: "tony.worron@fco.gsi.gov.uk", full_name: "Tony Worron", password: "password123", password_confirmation: "password123", role: "standard")
User.create(email: "stephen.mcallister@communities.gsi.gov.uk", full_name: "Stephen McAllister", password: "password123", password_confirmation: "password123", role: "standard")
