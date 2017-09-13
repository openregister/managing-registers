FactoryGirl.define do
  factory :team_member do
    role 'custodian'
    association :team
    association :user
  end
end
