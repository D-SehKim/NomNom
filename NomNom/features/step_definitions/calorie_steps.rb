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

Given("the following recipes exist:") do |table|
  table.hashes.each do |row|
    Recipe.find_or_create_by!(name: row['name'])
  end
end

Given("the following ingredients exist:") do |table|
  table.hashes.each do |row|
    Ingredient.find_or_create_by!(name: row['name'], calories_per_unit: row['calories_per_unit'].to_i)
  end
end

Given("I have a meal with the recipe {string} and {int} serving") do |recipe_name, servings|
  recipe = Recipe.find_or_create_by!(name: recipe_name)
  ingredient = recipe.recipe_ingredients.first&.ingredient || Ingredient.find_or_create_by!(name: "Salt", calories_per_unit: 100)
  RecipeIngredient.find_or_create_by!(recipe: recipe, ingredient: ingredient, quantity: 1)
  
  @meal = @user.user_meals.create!(recipe: recipe, servings: servings)
end

Given("I have added a custom ingredient {string} with quantity {int}") do |ingredient_name, quantity|
  ingredient = Ingredient.find_or_create_by!(name: ingredient_name, calories_per_unit: 50)
  meal = @user.user_meals.new(servings: 1)
  meal.user_meal_ingredients.build(ingredient: ingredient, quantity: quantity)
  meal.save!
end

Given("I have a meal with recipe {string} and {int} serving(s) and custom ingredients:") do |recipe_name, servings, table|
  recipe = Recipe.find_or_create_by!(name: recipe_name)

  if recipe.recipe_ingredients.empty?
    ingredient = Ingredient.find_or_create_by!(name: "Pancakes Base", calories_per_unit: 300)
    RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 1)
  end

  meal = @user.user_meals.create!(recipe: recipe, servings: servings)

  table.hashes.each do |row|
    ingredient = Ingredient.find_or_create_by!(name: row['name'], calories_per_unit: row['calories_per_unit'].to_i)
    meal.user_meal_ingredients.create!(ingredient: ingredient, quantity: row['quantity'].to_i)
  end
end


When("I visit the calorie tracker page") do
  visit user_meals_path
end

When("I visit the new meal page") do
  visit new_user_meal_path
end

When("I select {string} from the meal type") do |choice|
  select choice, from: "meal-choice"
end

When("I add the recipe {string} with {int} servings") do |recipe_name, servings|
  recipe = Recipe.find_or_create_by!(name: recipe_name)

  if recipe.recipe_ingredients.empty?
    ingredient = Ingredient.find_or_create_by!(name: "Flour", calories_per_unit: 100)
    RecipeIngredient.create!(recipe: recipe, ingredient: ingredient, quantity: 2)
  end

  @meal = @user.user_meals.create!(recipe: recipe, servings: servings)
  visit user_meals_path
end

When("I add the custom ingredient {string} with quantity {int}") do |ingredient_name, quantity|
  ingredient = Ingredient.find_or_create_by!(name: ingredient_name, calories_per_unit: 50)

  meal = @user.user_meals.new(servings: 1)
  meal.user_meal_ingredients.build(ingredient: ingredient, quantity: quantity)
  meal.save!
  
  visit user_meals_path
end

When("I remove the recipe {string}") do |recipe_name|
  visit user_meals_path
  
  # Target the "Recipes" section by <h2> heading
  within(:xpath, "//h2[normalize-space()='Recipes']/following::table[1]") do
    # Find the table row containing the recipe name
    within(:xpath, ".//tr[td[contains(., '#{recipe_name}')]]") do
      click_button "🗑️ Delete"  # or "Remove" if you changed the label in your ERB
    end
  end
end

When("I remove the custom ingredient {string}") do |ingredient_name|
  visit user_meals_path

  expect(page).to have_content(ingredient_name)

  container = find('div', text: /#{ingredient_name}/, match: :first, visible: true)
  within(container) do
    click_button "🗑️ Delete"
  end
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
  @user.user_meals.each do |meal|
    meal.user_meal_ingredients.each do |umi|
      expected_text = "#{umi.ingredient.name} — #{umi.quantity} × #{umi.ingredient.calories_per_unit} cal = #{umi.quantity * umi.ingredient.calories_per_unit} cal"
      expect(page).to have_content(expected_text)
    end
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

Then("I should see total calories for {string} equal to {int}") do |item_name, calories|
  meal = @user.user_meals.find { |m| m.recipe&.name == item_name }

  if meal
    expect(page).to have_content("#{meal.total_calories} cal")
  else
    umi = @user.user_meals.flat_map(&:user_meal_ingredients).find { |umi| umi.ingredient.name == item_name }

    raise "Ingredient #{item_name} not found" unless umi

    total = umi.quantity * umi.ingredient.calories_per_unit
    expect(total).to eq(calories)
    expect(page).to have_content("#{total} cal")
  end
end

Then("I should not see {string} on the calorie tracker") do |item_name|
  visit user_meals_path
  expect(page).to have_content("Calorie Tracker")
  expect(page).not_to have_content(item_name)
end

Then("I should see total calories consumed equal to {int}") do |expected_total|
  total = @user.user_meals.sum(&:total_calories)
  expect(total).to eq(expected_total)
end

