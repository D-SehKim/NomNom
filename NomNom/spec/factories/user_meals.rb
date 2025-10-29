FactoryBot.define do
  factory :user_meal do
    association :user
    association :recipe
    servings { 1 }

    after(:build) do |meal|
      meal.user_meal_ingredients << build(:user_meal_ingredient, user_meal: meal) if meal.user_meal_ingredients.empty? && meal.recipe.nil?
    end
  end
end