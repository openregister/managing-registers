FactoryBot.define do
  factory :register do
    key 'country'
    association :team
  end
end
