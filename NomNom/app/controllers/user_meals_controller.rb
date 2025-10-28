class UserMealsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch meals for current user (you can later filter by date)
    @user_meals = current_user.user_meals.includes(recipe: :recipe_ingredients, user_meal_ingredients: :ingredient)

    # Compute total calories consumed
    @total_calories = @user_meals.sum(&:total_calories)
  end

  def new
    @user_meal = current_user.user_meals.new
    @recipes = Recipe.all
    @ingredients = Ingredient.all
    @user_meal.user_meal_ingredients.build # for custom ingredients
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

  private

  def user_meal_params
    params.require(:user_meal).permit(
      :recipe_id,
      :servings,
      user_meal_ingredients_attributes: [:ingredient_id, :quantity]
    )
  end
end
