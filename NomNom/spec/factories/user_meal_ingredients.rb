FactoryBot.define do
  factory :user_meal_ingredient do
    association :user_meal
    association :ingredient
    quantity { 1 }
  end
end