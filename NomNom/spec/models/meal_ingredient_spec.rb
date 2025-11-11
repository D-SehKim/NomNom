require 'rails_helper'

RSpec.describe UserMealIngredient, type: :model do
  describe 'associations' do
    it { should belong_to(:user_meal) }
    it { should belong_to(:ingredient) }
  end
end
