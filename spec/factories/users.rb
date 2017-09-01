FactoryGirl.define do
  factory :user do 
    email 'testuser@gov.uk'
    full_name 'Admin'
    password 'password123'
    password_confirmation 'password123'
    invitation_accepted_at Date.today
    admin true
  end
end
