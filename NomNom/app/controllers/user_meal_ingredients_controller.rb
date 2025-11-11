class UserMealIngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_meal
  before_action :set_user_meal_ingredient, only: [:destroy]

  def destroy
    @user_meal_ingredient.destroy
    redirect_to user_meals_path, notice: "Ingredient removed successfully."
  end

  private

  def set_user_meal
    @user_meal = current_user.user_meals.find(params[:user_meal_id])
  end

  def set_user_meal_ingredient
    @user_meal_ingredient = @user_meal.user_meal_ingredients.find(params[:id])
  end
end
