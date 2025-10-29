class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  def total_calories
    recipe_ingredients.sum do |ri|
      ri.quantity.to_f * ri.ingredient.calories_per_unit.to_f
    end
  end
end
