class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :user_meal_ingredients
end
