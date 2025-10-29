require 'rails_helper'

RSpec.describe UserMealIngredientsController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:meal) { create(:user_meal, user: user, recipe: recipe) }
  let(:ingredient) { create(:ingredient) }
  let!(:user_meal_ingredient) { create(:user_meal_ingredient, user_meal: meal, ingredient: ingredient) }

  before { sign_in user }

  describe "DELETE #destroy" do
    context "when user is signed in" do
      it "deletes the ingredient" do
        expect {
          delete :destroy, params: { user_meal_id: meal.id, id: user_meal_ingredient.id }
        }.to change(UserMealIngredient, :count).by(-1)
      end

      it "redirects to user_meals_path with a success notice" do
        delete :destroy, params: { user_meal_id: meal.id, id: user_meal_ingredient.id }
        expect(response).to redirect_to(user_meals_path)
        expect(flash[:notice]).to eq("Ingredient removed successfully.")
      end
    end

    context "when ingredient does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          delete :destroy, params: { user_meal_id: meal.id, id: 9999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when meal does not belong to current user" do
      let(:other_user) { create(:user) }
      let(:other_meal) { create(:user_meal, user: other_user, recipe: recipe) }

      it "raises ActiveRecord::RecordNotFound" do
        expect {
          delete :destroy, params: { user_meal_id: other_meal.id, id: user_meal_ingredient.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is not signed in" do
      before { sign_out user }

      it "redirects to the sign-in page" do
        delete :destroy, params: { user_meal_id: meal.id, id: user_meal_ingredient.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
