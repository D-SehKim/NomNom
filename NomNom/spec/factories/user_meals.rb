FactoryBot.define do
  factory :user_meal do
    association :user
    association :recipe
    servings { 1 }
  end
end