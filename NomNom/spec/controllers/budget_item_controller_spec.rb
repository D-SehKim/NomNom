require 'rails_helper'

RSpec.describe BudgetItemsController, type: :controller do
  let(:user) { create(:user) }

  describe "authentication" do
    it "redirects to login when user is not authenticated" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is authenticated" do
    before { sign_in user }

    describe "GET #index" do
      let!(:item1) { create(:budget_item, user: user, amount: 100) }
      let!(:item2) { create(:budget_item, user: user, amount: 50) }
      let!(:other_item) { create(:budget_item) }

      it "assigns only the current user's budget items" do
        get :index
        expect(assigns(:budget_items)).to match_array([item1, item2])
      end

      it "calculates the total spent" do
        get :index
        expect(assigns(:total_spent)).to eq(150)
      end

      it "renders the index template successfully" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "assigns a new BudgetItem" do
        get :new
        expect(assigns(:budget_item)).to be_a_new(BudgetItem)
      end

      it "renders the new template successfully" do
        get :new
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      let(:budget_item) { create(:budget_item, user: user) }

      it "assigns the requested budget item" do
        get :edit, params: { id: budget_item.id }
        expect(assigns(:budget_item)).to eq(budget_item)
      end

      it "renders the edit template successfully" do
        get :edit, params: { id: budget_item.id }
        expect(response).to be_successful
      end

      it "raises an error if the budget item does not belong to the user" do
        other_item = create(:budget_item)
        expect {
          get :edit, params: { id: other_item.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "POST #create" do
      context "with valid parameters" do
        let(:valid_params) do
          { budget_item: { name: "Groceries", amount: 120, notes: "Weekly shopping" } }
        end

        it "creates a new budget item" do
          expect {
            post :create, params: valid_params
          }.to change(user.budget_items, :count).by(1)
        end

        it "redirects to budget_items_path with success notice" do
          post :create, params: valid_params
          expect(response).to redirect_to(budget_items_path)
          expect(flash[:notice]).to eq("Budget item added successfully.")
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { budget_item: { name: "", amount: nil } } }

        it "does not create a new budget item" do
          expect {
            post :create, params: invalid_params
          }.not_to change(BudgetItem, :count)
        end

        it "renders :new with unprocessable_entity status" do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH #update" do
      let(:budget_item) { create(:budget_item, user: user, name: "Old Name") }

      context "with valid parameters" do
        it "updates the budget item" do
          patch :update, params: { id: budget_item.id, budget_item: { name: "New Name" } }
          expect(budget_item.reload.name).to eq("New Name")
        end

        it "redirects to budget_items_path with success notice" do
          patch :update, params: { id: budget_item.id, budget_item: { name: "New Name" } }
          expect(response).to redirect_to(budget_items_path)
          expect(flash[:notice]).to eq("Budget item updated successfully.")
        end
      end

      context "with invalid parameters" do
        it "does not update the budget item" do
          patch :update, params: { id: budget_item.id, budget_item: { name: "" } }
          expect(budget_item.reload.name).to eq("Old Name")
        end

        it "renders :edit with unprocessable_entity status" do
          patch :update, params: { id: budget_item.id, budget_item: { name: "" } }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:budget_item) { create(:budget_item, user: user) }

      it "deletes the budget item" do
        expect {
          delete :destroy, params: { id: budget_item.id }
        }.to change(BudgetItem, :count).by(-1)
      end

      it "redirects to budget_items_path with success notice" do
        delete :destroy, params: { id: budget_item.id }
        expect(response).to redirect_to(budget_items_path)
        expect(flash[:notice]).to eq("Budget item removed.")
      end
    end
  end
end
