require 'rails_helper'

RSpec.describe UserMeal, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:ingredient) { create(:ingredient, calories_per_unit: 50) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:recipe).optional }
    it { should have_many(:user_meal_ingredients).dependent(:destroy) }
    it { should accept_nested_attributes_for(:user_meal_ingredients).allow_destroy(true) }
  end

  describe 'validations' do
    context 'when recipe is present' do
      it 'is valid without custom ingredients' do
        meal = build(:user_meal, user: user, recipe: recipe, user_meal_ingredients: [])
        expect(meal).to be_valid
      end
    end

    context 'when recipe is nil' do
      it 'is invalid without user_meal_ingredients' do
        user = create(:user)
        meal = build(:user_meal, user: user, recipe: nil)
        meal.user_meal_ingredients = []
        expect(meal).not_to be_valid
        expect(meal.errors[:user_meal_ingredients]).to include("can't be blank")
      end

      it 'is valid with at least one custom ingredient' do
        umi = build(:user_meal_ingredient, ingredient: ingredient, quantity: 2)
        meal = build(:user_meal, user: user, recipe: nil, user_meal_ingredients: [umi])
        expect(meal).to be_valid
      end
    end

    context 'when both recipe and custom ingredients are present' do
      it 'is valid' do
        umi = build(:user_meal_ingredient, ingredient: ingredient, quantity: 2)
        meal = build(:user_meal, user: user, recipe: recipe, user_meal_ingredients: [umi])
        expect(meal).to be_valid
      end
    end
  end

  describe 'calorie calculations' do
    let(:ingredient1) { create(:ingredient, calories_per_unit: 50) }
    let(:ingredient2) { create(:ingredient, calories_per_unit: 100) }

    let(:recipe_ingredient1) { create(:recipe_ingredient, ingredient: ingredient1, quantity: 2) }
    let(:recipe_ingredient2) { create(:recipe_ingredient, ingredient: ingredient2, quantity: 1) }

    let(:recipe) { create(:recipe, recipe_ingredients: [recipe_ingredient1, recipe_ingredient2]) }

    it 'calculates recipe_calories correctly' do
      meal = build(:user_meal, recipe: recipe, servings: 2)
      expected_calories = ((2*50) + (1*100)) * 2
      expect(meal.recipe_calories).to eq(expected_calories)
    end

    it 'calculates custom_calories correctly' do
      umi1 = build(:user_meal_ingredient, ingredient: ingredient1, quantity: 3)
      umi2 = build(:user_meal_ingredient, ingredient: ingredient2, quantity: 1)
      meal = build(:user_meal, recipe: nil, user_meal_ingredients: [umi1, umi2])
      expected_calories = (3*50) + (1*100)
      expect(meal.custom_calories).to eq(expected_calories)
    end

    it 'calculates total_calories correctly' do
      umi = build(:user_meal_ingredient, ingredient: ingredient1, quantity: 3)
      meal = build(:user_meal, recipe: recipe, servings: 1, user_meal_ingredients: [umi])
      expected_calories = meal.recipe_calories + meal.custom_calories
      expect(meal.total_calories).to eq(expected_calories)
    end
  end

  describe "nested attributes" do
    it "rejects user_meal_ingredients if ingredient_id is blank" do
      meal = UserMeal.new(user: user, recipe: nil, user_meal_ingredients_attributes: [{ ingredient_id: nil, quantity: 2 }])
      expect(meal.save).to be false
      expect(meal.user_meal_ingredients).to be_empty
    end

    it "rejects user_meal_ingredients if quantity is blank" do
      meal = UserMeal.new(user: user, recipe: nil, user_meal_ingredients_attributes: [{ ingredient_id: ingredient.id, quantity: nil }])
      expect(meal.save).to be false
      expect(meal.user_meal_ingredients).to be_empty
    end

    it "accepts valid user_meal_ingredients" do
      meal = UserMeal.new(user: user, recipe: nil, user_meal_ingredients_attributes: [{ ingredient_id: ingredient.id, quantity: 2 }])
      expect(meal.save).to be true
      expect(meal.user_meal_ingredients.size).to eq(1)
    end
  end
end
