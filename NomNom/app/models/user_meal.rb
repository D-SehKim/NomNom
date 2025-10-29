class UserMeal < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, optional: true
  has_many :user_meal_ingredients, dependent: :destroy
  accepts_nested_attributes_for :user_meal_ingredients, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['ingredient_id'].blank? || attributes['quantity'].blank? }

  validates :recipe_id, presence: true, if: -> { user_meal_ingredients.empty? }
  validates :user_meal_ingredients, presence: true, if: -> { recipe.nil? }

  # Total calories for recipe ingredients only
  def recipe_calories
    return 0 unless recipe.present?
    recipe.recipe_ingredients.sum { |ri| ri.ingredient.calories_per_unit * ri.quantity } * servings
  end

  # Total calories for custom/user-added ingredients only
  def custom_calories
    user_meal_ingredients.sum { |umi| umi.ingredient.calories_per_unit * umi.quantity }
  end

  # Total calories for everything
  def total_calories
    recipe_calories + custom_calories
  end
end