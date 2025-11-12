require 'rails_helper'

RSpec.describe BudgetItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end

  describe '.recent' do
    it 'orders items by created_at descending' do
      user = create(:user)
      older = create(:budget_item, user: user, created_at: 2.days.ago)
      newer = create(:budget_item, user: user, created_at: 1.day.ago)

      expect(described_class.recent).to eq([newer, older])
    end
  end
end
