class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  def calculate_total_calories
    recipe_ingredients.sum { |ri| ri.calories || ri.quantity * ri.ingredient.calories_per_unit }
  end
end