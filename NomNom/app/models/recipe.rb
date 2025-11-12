class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  before_save :calculate_total_calories
  accepts_nested_attributes_for :recipe_ingredients

  def total_calories
    recipe_ingredients.sum do |ri|
      ri.quantity.to_f * ri.ingredient.calories_per_unit.to_f
    end
  end

  private

  def calculate_total_calories
    self.total_calories = recipe_ingredients.sum do |ri|
      (ri.ingredient&.calories_per_unit.to_f || 0) * (ri.quantity.to_f || 1)
    end.round
  end
end
