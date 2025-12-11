FactoryBot.define do
  factory :item do
    name { "Sample Item" }
    expires_at { 1.week.from_now }
    association :user
  end
end