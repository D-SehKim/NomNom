class UserMeal < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  has_many :user_meal_ingredients
  has_many :ingredients, through: :user_meal_ingredients

  accepts_nested_attributes_for :user_meal_ingredients, allow_destroy: true

  def total_calories
    recipe_calories = recipe.total_calories.to_i * (servings || 1)
    extra_ingredient_calories = user_meal_ingredients.sum { |umi| umi.quantity.to_i * umi.ingredient.calories_per_unit.to_i }
    recipe_calories + extra_ingredient_calories
  end
end
