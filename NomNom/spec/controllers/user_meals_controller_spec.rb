require 'rails_helper'

RSpec.describe UserMealsController, type: :controller do
  let(:user) { create(:user) }
  let!(:user_meal) { create(:user_meal, user: user) }
  let(:recipe) { create(:recipe) }
  let(:ingredient) { create(:ingredient) }
  let!(:meal) { create(:user_meal, user: user, recipe: recipe) }
  let!(:umi) { create(:user_meal_ingredient, user_meal: meal, ingredient: ingredient) }
  let(:other_user) { create(:user) }
  let(:other_meal) { create(:user_meal, user: other_user) }
  let!(:other_umi) { create(:user_meal_ingredient, user_meal: other_meal) }

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

  describe "POST #create with invalid parameters" do
    before do
        sign_in user
    end

    it "renders :new with all recipes and ingredients assigned" do
        post :create, params: { user_meal: { servings: 1, user_meal_ingredients_attributes: [] } }

        expect(response).to render_template(:new)
        expect(assigns(:recipes)).to eq(Recipe.all)
        expect(assigns(:ingredients)).to eq(Ingredient.all)
    end
  end

  describe "DELETE #destroy_ingredient" do
    it "destroys the ingredient" do
      expect {
        delete :destroy_ingredient, params: { id: umi.id }
      }.to change(UserMealIngredient, :count).by(-1)

      expect(response).to redirect_to(user_meals_path)
      expect(flash[:notice]).to eq("Ingredient removed.")
    end

    it "does not allow deleting another user's ingredient" do
      expect {
        delete :destroy_ingredient, params: { id: other_umi.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "DELETE #destroy" do
    context "when deleting own meal" do
      it "destroys the user meal" do
        expect {
          delete :destroy, params: { id: user_meal.id }
        }.to change(UserMeal, :count).by(-1)
      end

      it "redirects to user_meals_path with a notice" do
        delete :destroy, params: { id: user_meal.id }
        expect(response).to redirect_to(user_meals_path)
        expect(flash[:notice]).to eq("Meal removed successfully!")
      end
    end

    context "when trying to delete another user's meal" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          delete :destroy, params: { id: other_meal.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

