require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe '#total_calories' do
    let(:ingredient1) { create(:ingredient, calories_per_unit: 50) }
    let(:ingredient2) { create(:ingredient, calories_per_unit: 100) }
    let(:recipe) { create(:recipe) }

    before do
        create(:recipe_ingredient, recipe: recipe, ingredient: ingredient1, quantity: 2)   # 2 * 50 = 100
        create(:recipe_ingredient, recipe: recipe, ingredient: ingredient2, quantity: 1) # 1 * 100 = 100
    end

    it 'calculates the total calories of all ingredients in the recipe' do
      expected_calories = (2 * 50) + (1 * 100) # 200
      expect(recipe.total_calories).to eq(expected_calories)
    end

    it 'returns 0 if there are no ingredients' do
      empty_recipe = create(:recipe)
      expect(empty_recipe.total_calories).to eq(0)
    end
  end
end
