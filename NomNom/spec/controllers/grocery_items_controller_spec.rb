require 'rails_helper'

RSpec.describe GroceryItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:grocery_item) { create(:grocery_item, user: user) }

  describe "authentication" do
    it "redirects to login when user is not authenticated" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is authenticated" do
    before { sign_in user }

    describe "GET #index" do
        let!(:purchased_item) { create(:grocery_item, :purchased, user: user) }
        let!(:not_purchased_item) { create(:grocery_item, :not_purchased, user: user) }
        let!(:other_user_item) { create(:grocery_item, user: create(:user)) }

        before { get :index }

        it { expect(response).to be_successful }
        
        it "loads only current user's grocery items" do
        expect(assigns(:grocery_items)).to match_array([purchased_item, not_purchased_item])
        end

        it "separates items by purchase status" do
        expect(assigns(:purchased)).to eq([purchased_item])
        expect(assigns(:not_purchased)).to eq([not_purchased_item])
        end
    end

    describe "GET #new" do
        before { get :new }

        it { expect(response).to be_successful }
        it { expect(assigns(:grocery_item)).to be_a_new(GroceryItem) }
    end

    describe "GET #edit" do
        before { get :edit, params: { id: grocery_item.to_param } }

        it { expect(response).to be_successful }
        it { expect(assigns(:grocery_item)).to eq(grocery_item) }
    end

    describe "POST #create" do
        let(:valid_attributes) { { name: "Milk", quantity: "2L", notes: "Organic preferred" } }
        let(:invalid_attributes) { { name: "", quantity: "" } }

        context "with valid params" do
        subject(:create_item) { post :create, params: { grocery_item: valid_attributes } }

        it { expect { create_item }.to change(GroceryItem, :count).by(1) }
        
        it "associates item with current user" do
            create_item
            expect(GroceryItem.last.user).to eq(user)
        end

        it "redirects with success message" do
            create_item
            expect(response).to redirect_to(grocery_items_path)
            expect(flash[:notice]).to eq("Item added to grocery list successfully.")
        end
        end

        context "with invalid params" do
        subject(:create_invalid) { post :create, params: { grocery_item: invalid_attributes } }

        it { expect { create_invalid }.not_to change(GroceryItem, :count) }
        
        it "renders new template with unprocessable entity status" do
            create_invalid
            expect(response).to have_http_status(:unprocessable_entity)
        end
        end
    end

    describe "PUT #update" do
        let(:new_attributes) { { name: "Updated Item", quantity: "3", notes: "Updated notes" } }
        let(:invalid_attributes) { { name: "", quantity: "" } }

        context "with valid params" do
        subject(:update_item) { put :update, params: { id: grocery_item.to_param, grocery_item: new_attributes } }

        it "updates the grocery item attributes" do
            expect { update_item }.to change { grocery_item.reload.name }.to("Updated Item")
            .and change { grocery_item.quantity }.to("3")
            .and change { grocery_item.notes }.to("Updated notes")
        end

        it "redirects with success message" do
            update_item
            expect(response).to redirect_to(grocery_items_path)
            expect(flash[:notice]).to eq("Item updated successfully.")
        end
        end

        context "with invalid params" do
        subject(:update_invalid) { put :update, params: { id: grocery_item.to_param, grocery_item: invalid_attributes } }

        it "does not update the item" do
            expect { update_invalid }.not_to change { grocery_item.reload.name }
        end

        it "renders edit template with unprocessable entity status" do
            update_invalid
            expect(response).to have_http_status(:unprocessable_entity)
        end
        end
    end

    describe "DELETE #destroy" do
        let!(:item_to_delete) { create(:grocery_item, user: user) }
        subject(:delete_item) { delete :destroy, params: { id: item_to_delete.to_param } }

        it { expect { delete_item }.to change(GroceryItem, :count).by(-1) }

        it "redirects with success message" do
        delete_item
        expect(response).to redirect_to(grocery_items_path)
        expect(flash[:notice]).to eq("Item removed from grocery list.")
        end
    end

    describe "PATCH #toggle_purchased" do
        context "when item is not purchased" do
        let(:item) { create(:grocery_item, :not_purchased, user: user) }

        it "marks item as purchased" do
            expect { 
            patch :toggle_purchased, params: { id: item.to_param }
            }.to change { item.reload.purchased }.from(false).to(true)
        end

        it "redirects to grocery items list" do
            patch :toggle_purchased, params: { id: item.to_param }
            expect(response).to redirect_to(grocery_items_path)
        end
        end

        context "when item is purchased" do
        let(:item) { create(:grocery_item, :purchased, user: user) }

        it "marks item as not purchased" do
            expect { 
            patch :toggle_purchased, params: { id: item.to_param }
            }.to change { item.reload.purchased }.from(true).to(false)
        end

        it "redirects to grocery items list" do
            patch :toggle_purchased, params: { id: item.to_param }
            expect(response).to redirect_to(grocery_items_path)
        end
        end
    end

    describe "authentication and authorization" do
        context "when user is not signed in" do
        before { sign_out user }

        it "redirects index to sign in page" do
            get :index
            expect(response).to redirect_to(new_user_session_path)
        end

        it "redirects new to sign in page" do
            get :new
            expect(response).to redirect_to(new_user_session_path)
        end
        end

        context "when accessing another user's items" do
        let(:other_item) { create(:grocery_item, user: create(:user)) }

        it "raises not found for edit" do
            expect { get :edit, params: { id: other_item.to_param } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises not found for update" do
            expect { put :update, params: { id: other_item.to_param, grocery_item: { name: "Hacked" } } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises not found for destroy" do
            expect { delete :destroy, params: { id: other_item.to_param } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end

        it "raises not found for toggle_purchased" do
            expect { patch :toggle_purchased, params: { id: other_item.to_param } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
        end
    end
    end
end