require 'rails_helper'

RSpec.describe UserMealsController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:ingredient) { create(:ingredient) }
  let!(:ingredient1) { create(:ingredient) }
  let!(:ingredient2) { create(:ingredient) } 
  let!(:meal) { create(:user_meal, user: user, recipe: recipe) }
  let!(:umi) { create(:user_meal_ingredient, user_meal: meal, ingredient: ingredient) }

  before { sign_in user }

  describe "GET #index" do
    it "assigns user meals and total calories" do
      get :index
      expect(assigns(:user_meals)).to include(meal)
      expect(assigns(:total_calories)).to eq(meal.total_calories)
    end
  end

  describe "GET #new" do
    it "builds a new meal and ingredient" do
      get :new
      expect(assigns(:user_meal)).to be_a_new(UserMeal)
      expect(assigns(:recipes)).to include(recipe)
      expect(assigns(:ingredients)).to include(ingredient)
      expect(assigns(:user_meal).user_meal_ingredients.first).to be_a_new(UserMealIngredient)
    end
  end

  describe "GET #new" do
    before { get :new }

    it "assigns a new user meal" do
      expect(assigns(:user_meal)).to be_a_new(UserMeal)
    end

    it "assigns all recipes" do
      expect(assigns(:recipes)).to match_array([recipe])
    end

    it "assigns all ingredients" do
      expect(assigns(:ingredients)).to include(ingredient1, ingredient2)
    end

    it "builds a new user_meal_ingredient" do
      expect(assigns(:user_meal).user_meal_ingredients.size).to eq(1)
      expect(assigns(:user_meal).user_meal_ingredients.first).to be_a_new(UserMealIngredient)
    end

    it "renders the :new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a meal and redirects" do
        expect {
          post :create, params: { user_meal: { recipe_id: recipe.id, servings: 1 } }
        }.to change(UserMeal, :count).by(1)
        expect(response).to redirect_to(user_meals_path)
        expect(flash[:notice]).to eq("Meal added successfully!")
      end
    end
  end

  describe "DELETE #clear_all" do
    before do
      create_list(:user_meal, 3, user: user)
    end

    it "deletes all meals for current user" do
      expect {
        delete :clear_all
      }.to change { user.user_meals.count }.to(0)
      expect(response).to redirect_to(user_meals_path)
      expect(flash[:notice]).to eq("All meals and custom ingredients have been cleared!")
    end
  end
end

