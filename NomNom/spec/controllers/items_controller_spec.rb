require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:item) { create(:item) }
  
  describe "authentication" do
    it "redirects to login when user is not authenticated" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is authenticated" do
    before { sign_in user }

    describe "GET #index" do
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end

      it "assigns a new item to @item" do
        get :new
        expect(assigns(:item)).to be_a_new(Item)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        let(:valid_attributes) { { name: "Test Item", expires_at: 1.week.from_now } }

        it "creates a new Item" do
          expect {
            post :create, params: { item: valid_attributes }
          }.to change(Item, :count).by(1)
        end

        it "redirects to the items list" do
          post :create, params: { item: valid_attributes }
          expect(response).to redirect_to(items_path)
        end

        it "sets a success notice" do
          post :create, params: { item: valid_attributes }
          expect(flash[:notice]).to eq("Item added successfully.")
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested item" do
        item_to_delete = create(:item)
        expect {
          delete :destroy, params: { id: item_to_delete.id }
        }.to change(Item, :count).by(-1)
      end

      it "redirects to the items list" do
        delete :destroy, params: { id: item.id }
        expect(response).to redirect_to(items_path)
      end

      it "sets a success notice" do
        delete :destroy, params: { id: item.id }
        expect(flash[:notice]).to eq("Item deleted successfully.")
      end

      it "raises an error when item is not found" do
        expect {
          delete :destroy, params: { id: 9999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end