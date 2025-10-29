FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    quantity { 1 }
  end
end