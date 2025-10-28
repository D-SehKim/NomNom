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
RecipeIngredient.destroy_all
Ingredient.destroy_all
Recipe.destroy_all

# Ingredients
flour = Ingredient.create!(name: "Flour", calories_per_unit: 50)   # per 10g
sugar = Ingredient.create!(name: "Sugar", calories_per_unit: 16)   # per 10g
butter = Ingredient.create!(name: "Butter", calories_per_unit: 72) # per 10g
egg = Ingredient.create!(name: "Egg", calories_per_unit: 70)       # per egg
milk = Ingredient.create!(name: "Milk", calories_per_unit: 42)     # per 100ml
chocolate = Ingredient.create!(name: "Chocolate", calories_per_unit: 55) # per 10g

# Recipes
pancakes = Recipe.create!(name: "Pancakes", description: "Fluffy breakfast pancakes")
chocolate_cake = Recipe.create!(name: "Chocolate Cake", description: "Rich and moist cake")

# RecipeIngredients for Pancakes
pancakes.recipe_ingredients.create!(ingredient: flour, quantity: 200, calories: 1000)
pancakes.recipe_ingredients.create!(ingredient: milk, quantity: 200, calories: 84)
pancakes.recipe_ingredients.create!(ingredient: egg, quantity: 2, calories: 140)
pancakes.recipe_ingredients.create!(ingredient: butter, quantity: 50, calories: 360)
pancakes.recipe_ingredients.create!(ingredient: sugar, quantity: 30, calories: 48)

# RecipeIngredients for Chocolate Cake
chocolate_cake.recipe_ingredients.create!(ingredient: flour, quantity: 250, calories: 1250)
chocolate_cake.recipe_ingredients.create!(ingredient: sugar, quantity: 150, calories: 240)
chocolate_cake.recipe_ingredients.create!(ingredient: butter, quantity: 100, calories: 720)
chocolate_cake.recipe_ingredients.create!(ingredient: egg, quantity: 3, calories: 210)
chocolate_cake.recipe_ingredients.create!(ingredient: chocolate, quantity: 200, calories: 1100)
chocolate_cake.recipe_ingredients.create!(ingredient: milk, quantity: 150, calories: 63)

puts "Seeded #{Recipe.count} recipes, #{Ingredient.count} ingredients, and #{RecipeIngredient.count} recipe_ingredients."