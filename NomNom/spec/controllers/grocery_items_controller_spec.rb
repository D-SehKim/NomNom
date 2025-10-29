require 'rails_helper'

RSpec.describe GroceryItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:grocery_item) { create(:grocery_item, user: user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let!(:purchased_item) { create(:grocery_item, :purchased, user: user) }
    let!(:not_purchased_item) { create(:grocery_item, :not_purchased, user: user) }

    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "loads user's grocery items" do
      get :index
      expect(assigns(:grocery_items)).to include(purchased_item, not_purchased_item)
    end

    it "separates purchased and not purchased items" do
      get :index
      expect(assigns(:purchased)).to include(purchased_item)
      expect(assigns(:not_purchased)).to include(not_purchased_item)
    end

    it "does not show other users' items" do
      other_user = create(:user)
      other_item = create(:grocery_item, user: other_user)
      
      get :index
      expect(assigns(:grocery_items)).not_to include(other_item)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new grocery_item" do
      get :new
      expect(assigns(:grocery_item)).to be_a_new(GroceryItem)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: grocery_item.to_param }
      expect(response).to be_successful
    end

    it "assigns the requested grocery_item" do
      get :edit, params: { id: grocery_item.to_param }
      expect(assigns(:grocery_item)).to eq(grocery_item)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) {
        { name: "Milk", quantity: "2L", notes: "Organic preferred" }
      }

      it "creates a new GroceryItem" do
        expect {
          post :create, params: { grocery_item: valid_attributes }
        }.to change(GroceryItem, :count).by(1)
      end

      it "assigns the grocery item to the current user" do
        post :create, params: { grocery_item: valid_attributes }
        expect(assigns(:grocery_item).user).to eq(user)
      end

      it "redirects to the grocery items list" do
        post :create, params: { grocery_item: valid_attributes }
        expect(response).to redirect_to(grocery_items_path)
      end

      it "sets a success notice" do
        post :create, params: { grocery_item: valid_attributes }
        expect(flash[:notice]).to eq("Item added to grocery list successfully.")
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        { name: "", quantity: "" }
      }

      it "returns a success response (to display the 'new' template)" do
        post :create, params: { grocery_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a grocery item" do
        expect {
          post :create, params: { grocery_item: invalid_attributes }
        }.not_to change(GroceryItem, :count)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "Updated Item", quantity: "3", notes: "Updated notes" }
      }

      it "updates the requested grocery_item" do
        put :update, params: { id: grocery_item.to_param, grocery_item: new_attributes }
        grocery_item.reload
        expect(grocery_item.name).to eq("Updated Item")
        expect(grocery_item.quantity).to eq("3")
        expect(grocery_item.notes).to eq("Updated notes")
      end

      it "redirects to the grocery items list" do
        put :update, params: { id: grocery_item.to_param, grocery_item: new_attributes }
        expect(response).to redirect_to(grocery_items_path)
      end

      it "sets a success notice" do
        put :update, params: { id: grocery_item.to_param, grocery_item: new_attributes }
        expect(flash[:notice]).to eq("Item updated successfully.")
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        { name: "", quantity: "" }
      }

      it "returns a success response (to display the 'edit' template)" do
        put :update, params: { id: grocery_item.to_param, grocery_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the grocery item" do
        original_name = grocery_item.name
        put :update, params: { id: grocery_item.to_param, grocery_item: invalid_attributes }
        grocery_item.reload
        expect(grocery_item.name).to eq(original_name)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested grocery_item" do
      grocery_item # Create the item
      expect {
        delete :destroy, params: { id: grocery_item.to_param }
      }.to change(GroceryItem, :count).by(-1)
    end

    it "redirects to the grocery items list" do
      delete :destroy, params: { id: grocery_item.to_param }
      expect(response).to redirect_to(grocery_items_path)
    end

    it "sets a success notice" do
      delete :destroy, params: { id: grocery_item.to_param }
      expect(flash[:notice]).to eq("Item removed from grocery list.")
    end
  end

  describe "PATCH #toggle_purchased" do
    context "when item is not purchased" do
      let(:unpurchased_item) { create(:grocery_item, :not_purchased, user: user) }

      it "marks item as purchased" do
        patch :toggle_purchased, params: { id: unpurchased_item.to_param }
        unpurchased_item.reload
        expect(unpurchased_item.purchased).to be_truthy
      end
    end

    context "when item is purchased" do
      let(:purchased_item) { create(:grocery_item, :purchased, user: user) }

      it "marks item as not purchased" do
        patch :toggle_purchased, params: { id: purchased_item.to_param }
        purchased_item.reload
        expect(purchased_item.purchased).to be_falsey
      end
    end

    it "redirects to grocery items list" do
      patch :toggle_purchased, params: { id: grocery_item.to_param }
      expect(response).to redirect_to(grocery_items_path)
    end
  end

  describe "authentication" do
    context "when user is not signed in" do
      before { sign_out user }

      it "redirects to sign in page for index" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects to sign in page for new" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "user scoping" do
    let(:other_user) { create(:user) }
    let(:other_item) { create(:grocery_item, user: other_user) }

    it "does not allow editing other user's items" do
      expect {
        get :edit, params: { id: other_item.to_param }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not allow updating other user's items" do
      expect {
        put :update, params: { id: other_item.to_param, grocery_item: { name: "Hacked" } }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not allow deleting other user's items" do
      expect {
        delete :destroy, params: { id: other_item.to_param }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
