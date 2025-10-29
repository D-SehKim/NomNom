Given("I am logged in as a user") do
  @user = User.find_or_create_by!(email: "test@nomnom.com") do |u|
    u.password = "password"
    u.password_confirmation = "password"
  end
  login_as(@user, scope: :user)
end

Given("I have a meal with the recipe {string}") do |recipe_name|
  recipe = Recipe.find_or_create_by!(name: recipe_name)
  @meal = @user.user_meals.create!(recipe: recipe, servings: 1)
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

