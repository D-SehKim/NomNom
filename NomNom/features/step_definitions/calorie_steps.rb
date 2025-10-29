Given("I have a meal with the recipe {string}") do |recipe_name|
  recipe = Recipe.find_or_create_by!(name: recipe_name)
  ingredient = Ingredient.find_or_create_by!(name: "Flour", calories_per_unit: 100)
  RecipeIngredient.find_or_create_by!(recipe: recipe, ingredient: ingredient, quantity: 2)

  @meal = @user.user_meals.create!(recipe: recipe, servings: 1, created_at: Time.zone.today)
end

Given("I have a custom ingredient {string}") do |ingredient_name|
  ingredient = Ingredient.find_or_create_by!(name: ingredient_name, calories_per_unit: 50)
  @meal = @user.user_meals.new(servings: 1)
  @meal.user_meal_ingredients.build(ingredient: ingredient, quantity: 1)
  @meal.save!
end

Given("I have custom ingredients logged for today") do
  sugar = Ingredient.find_or_create_by!(name: "Sugar", calories_per_unit: 50)
  salt  = Ingredient.find_or_create_by!(name: "Salt", calories_per_unit: 10)
  meal = @user.user_meals.new(servings: 1)

  meal.user_meal_ingredients.build(ingredient: sugar, quantity: 2)
  meal.user_meal_ingredients.build(ingredient: salt, quantity: 1)

  meal.save!
end

Given("I have meals logged for today") do
  step %{I have a meal with the recipe "Chocolate Cake"}
  step %{I have a custom ingredient "Salt"}
end

When("I visit the calorie tracker page") do
  visit user_meals_path
end

Then("I should see {string} listed") do |name|
  expect(page).to have_content(name)
end

Then("I should see the calories for each recipe ingredient") do
  @meal.recipe.recipe_ingredients.each do |ri|
    calories = ri.quantity * ri.ingredient.calories_per_unit
    expect(page).to have_content("#{calories} cal")
  end
end

Then("I should see the total calories for the recipe") do
  total = @meal.total_calories
  expect(page).to have_content("Total for this recipe: #{total} cal")
end

Then("I should see the calories for the ingredient") do
  @meal.user_meal_ingredients.each do |umi|
    expected_text = "#{umi.ingredient.name} — #{umi.quantity} × #{umi.ingredient.calories_per_unit} cal = #{umi.quantity * umi.ingredient.calories_per_unit} cal"
    expect(page).to have_content(expected_text)
  end
end

Then("I should see the total calories consumed for custom ingredients") do
  total = @user.user_meals.sum do |meal|
    meal.user_meal_ingredients.sum { |umi| umi.quantity * umi.ingredient.calories_per_unit }
  end
  expect(page).to have_content("Total Calories for All Custom Ingredients: #{total} cal")
end

Then("I should see the total calories consumed for everything") do
  total = @user.user_meals.sum(&:total_calories)
  expect(page).to have_content("Total Calories Consumed: #{total} cal")
end
