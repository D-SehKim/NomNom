# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
User.destroy_all
UserMealIngredient.destroy_all
UserMeal.destroy_all
RecipeIngredient.destroy_all
Recipe.destroy_all
Ingredient.destroy_all

User.find_or_create_by!(email: "test@nomnom.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

# Ingredients (calories per 1g or 1ml or per unit)
flour      = Ingredient.create!(name: "Flour", calories_per_unit: 3.64)    # per gram
sugar      = Ingredient.create!(name: "Sugar", calories_per_unit: 3.87)    # per gram
butter     = Ingredient.create!(name: "Butter", calories_per_unit: 7.17)   # per gram
egg        = Ingredient.create!(name: "Egg", calories_per_unit: 70)         # per egg
milk       = Ingredient.create!(name: "Milk", calories_per_unit: 0.42)     # per ml
chocolate  = Ingredient.create!(name: "Chocolate", calories_per_unit: 5.5) # per gram

# Recipes
pancakes = Recipe.create!(name: "Pancakes", description: "Fluffy breakfast pancakes")
chocolate_cake = Recipe.create!(name: "Chocolate Cake", description: "Rich and moist cake")

# RecipeIngredients for Pancakes
pancakes.recipe_ingredients.create!(ingredient: flour, quantity: 200)   # 200g
pancakes.recipe_ingredients.create!(ingredient: milk, quantity: 200)    # 200ml
pancakes.recipe_ingredients.create!(ingredient: egg, quantity: 2)       # 2 eggs
pancakes.recipe_ingredients.create!(ingredient: butter, quantity: 50)   # 50g
pancakes.recipe_ingredients.create!(ingredient: sugar, quantity: 30)    # 30g

# RecipeIngredients for Chocolate Cake
chocolate_cake.recipe_ingredients.create!(ingredient: flour, quantity: 250)
chocolate_cake.recipe_ingredients.create!(ingredient: sugar, quantity: 150)
chocolate_cake.recipe_ingredients.create!(ingredient: butter, quantity: 100)
chocolate_cake.recipe_ingredients.create!(ingredient: egg, quantity: 3)
chocolate_cake.recipe_ingredients.create!(ingredient: chocolate, quantity: 200)
chocolate_cake.recipe_ingredients.create!(ingredient: milk, quantity: 150)

puts "Seeded #{Recipe.count} recipes, #{Ingredient.count} ingredients, and #{RecipeIngredient.count} recipe_ingredients."
