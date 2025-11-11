class UserMealsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_meals = current_user.user_meals.includes(recipe: :recipe_ingredients, user_meal_ingredients: :ingredient)
    @total_calories = @user_meals.sum(&:total_calories)
  end

  def new
    @user_meal = current_user.user_meals.new
    @recipes = Recipe.all
    @ingredients = Ingredient.all
    @user_meal.user_meal_ingredients.build
  end

  def create
    @user_meal = current_user.user_meals.new(user_meal_params)

    if @user_meal.save
      redirect_to user_meals_path, notice: "Meal added successfully!"
    else
      @recipes = Recipe.all
      @ingredients = Ingredient.all
      render :new
    end
  end

  def clear_all
    current_user.user_meals.destroy_all
    redirect_to user_meals_path, notice: "All meals and custom ingredients have been cleared!"
  end

  # def destroy_ingredient
  #   umi = UserMealIngredient.find(params[:id])
  #   umi.destroy
  #   redirect_to user_meals_path, notice: "Ingredient removed."
  # end
  def destroy_ingredient
    # ensure the ingredient belongs to the current user's meal
    umi = UserMealIngredient.joins(:user_meal)
            .where(user_meals: { user_id: current_user.id })
            .find(params[:id])

    umi.destroy
    redirect_to user_meals_path, notice: "Ingredient removed."
  end

  def destroy
    @user_meal = current_user.user_meals.find(params[:id])
    @user_meal.destroy
    redirect_to user_meals_path, notice: "Meal removed successfully!"
  end


  private

  def user_meal_params
    params.require(:user_meal).permit(
      :recipe_id,
      :servings,
      user_meal_ingredients_attributes: [:ingredient_id, :quantity]
    )
  end
end
