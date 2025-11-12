class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :user_meal_ingredients
  has_many :recipes, through: :recipe_ingredients
end
