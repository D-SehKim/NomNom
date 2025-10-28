class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :user_meal_ingredients, dependent: :destroy
  has_many :user_meals, through: :user_meal_ingredients
end
