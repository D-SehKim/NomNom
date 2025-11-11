class UserMealIngredient < ApplicationRecord
  belongs_to :user_meal
  belongs_to :ingredient
end
