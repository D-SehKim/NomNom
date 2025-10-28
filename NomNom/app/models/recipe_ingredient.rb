class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  before_save :calculate_calories

  private

  def calculate_calories
    self.calories ||= quantity * ingredient.calories_per_unit
  end
end
