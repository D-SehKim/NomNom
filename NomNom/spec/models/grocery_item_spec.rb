require 'rails_helper'

RSpec.describe GroceryItem, type: :model do
  let(:user) { create(:user) }
  
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:quantity) }
  end

  describe 'scopes' do
    let!(:purchased_item) { create(:grocery_item, user: user, purchased: true) }
    let!(:not_purchased_item) { create(:grocery_item, user: user, purchased: false) }

    describe '.purchased' do
      it 'returns only purchased items' do
        expect(GroceryItem.purchased).to include(purchased_item)
        expect(GroceryItem.purchased).not_to include(not_purchased_item)
      end
    end

    describe '.not_purchased' do
      it 'returns only non-purchased items' do
        expect(GroceryItem.not_purchased).to include(not_purchased_item)
        expect(GroceryItem.not_purchased).not_to include(purchased_item)
      end
    end

    describe '.recent' do
      it 'orders items by creation date descending' do
        older_item = create(:grocery_item, user: user)
        sleep(0.1) # Ensure different timestamps
        newer_item = create(:grocery_item, user: user)
        
        items = GroceryItem.recent.to_a
        expect(items.first.created_at).to be >= items.last.created_at
      end
    end
  end

  describe 'default values' do
    it 'sets purchased to false by default' do
      item = build(:grocery_item, user: user)
      expect(item.purchased).to be_falsey
    end

    it 'sets quantity to "1" by default' do
      item = GroceryItem.new(name: "Test Item", user: user)
      item.save
      expect(item.quantity).to eq("1")
    end
  end

  describe 'instance methods' do
    let(:grocery_item) { create(:grocery_item, user: user) }

    it 'can be marked as purchased' do
      grocery_item.update(purchased: true)
      expect(grocery_item.purchased).to be_truthy
    end

    it 'can be marked as not purchased' do
      grocery_item.update(purchased: false)
      expect(grocery_item.purchased).to be_falsey
    end
  end

  describe 'user association' do
    it 'belongs to a user' do
      item = create(:grocery_item, user: user)
      expect(item.user).to eq(user)
    end

    it 'is destroyed when user is destroyed' do
      item = create(:grocery_item, user: user)
      expect { user.destroy }.to change { GroceryItem.count }.by(-1)
    end
  end
end
