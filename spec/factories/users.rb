FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    password 'password123'
    password_confirmation 'password123'
    invitation_accepted_at Date.today

    trait :admin do
      admin true
    end
  end
end
