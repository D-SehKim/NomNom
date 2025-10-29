FactoryBot.define do
  factory :item do
    name { "Test Item" }
    expires_at { 1.week.from_now }
  end
end
