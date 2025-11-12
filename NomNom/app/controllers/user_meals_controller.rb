class UserMealsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_meals = current_user.user_meals.includes(
      recipe: :recipe_ingredients,
      user_meal_ingredients: :ingredient
    )
    @total_calories = @user_meals.sum(&:total_calories).to_i
  end

  def new
    @user_meal = current_user.user_meals.new
    @recipes = Recipe.all
    @ingredients = Ingredient.all
    @user_meal.user_meal_ingredients.build
  end

  def create
    @recipes = Recipe.all
    @ingredients = Ingredient.all
    @user_meal = current_user.user_meals.new(user_meal_params)

    # Handle servings
    servings = params[:user_meal][:servings].to_i
    @user_meal.servings = servings > 0 ? servings : 1

    # --- New Recipe ---
    if params[:new_recipe].present? && params[:new_recipe][:name].present?
      new_recipe_params = params[:new_recipe]

      recipe = Recipe.new(
        name: new_recipe_params[:name],
        description: new_recipe_params[:description]
      )

      (new_recipe_params[:recipe_ingredients_attributes] || {}).each do |_, ri|
        next if ri[:quantity].blank?

        ingredient =
          if ri[:ingredient_id].present? && ri[:ingredient_id] != "new"
            Ingredient.find_by(id: ri[:ingredient_id])
          elsif ri.dig(:ingredient_attributes, :name).present?
            Ingredient.find_or_create_by(name: ri[:ingredient_attributes][:name].strip) do |ing|
              ing.calories_per_unit = ri[:ingredient_attributes][:calories_per_unit].to_f
            end
          end

        next unless ingredient

        recipe.recipe_ingredients.build(
          ingredient: ingredient,
          quantity: ri[:quantity].to_f
        )
      end

      recipe.total_calories = recipe.recipe_ingredients.sum { |ri| ri.ingredient.calories_per_unit * ri.quantity }.to_i

      if recipe.save
        @user_meal.recipe = recipe
      else
        flash.now[:alert] = "Error creating recipe: #{recipe.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity and return
      end
    end

    # --- Validate selection ---
    if @user_meal.recipe.nil? && @user_meal.user_meal_ingredients.empty?
      flash.now[:alert] = "You must select a recipe or add custom ingredients"
      render :new, status: :unprocessable_entity and return
    end

    if @user_meal.save
      redirect_to user_meals_path, notice: "Meal added successfully!"
    else
      flash.now[:alert] = "Error saving meal: #{@user_meal.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def clear_all
    current_user.user_meals.destroy_all
    redirect_to user_meals_path, notice: "All meals cleared!"
  end

  def destroy_ingredient
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

