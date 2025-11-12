Feature: Add a new recipe to add to my calorie tracker

  As a user
  So that I can log meals using recipes
  I want to be able to create a new recipe with ingredients

Scenario: Creating a new recipe with existing ingredients
  Given I am logged in as a user
  And the following ingredients exist:
    | name  | calories_per_unit |
    | Flour | 100              |
    | Egg   | 70               |
  When I visit the new meal page
  And I fill in the new recipe name with "French Toast"
  And I fill in the new recipe description with "Delicious breakfast"
  And I add "Flour" with quantity 2 to the recipe
  And I add "Egg" with quantity 1 to the recipe
  And I submit the new recipe
  Then I should see "French Toast" listed
  And I should see total calories for "French Toast" equal to 270

Scenario: Creating a new recipe with a new ingredient
  Given I am logged in as a user
  When I visit the new meal page
  And I fill in the new recipe name with "Protein Shake"
  And I fill in the new recipe description with "Healthy drink"
  And I add a new ingredient "Protein Powder" with 120 calories per unit and quantity 2
  And I submit the new recipe
  Then I should see "Protein Shake" listed
  And I should see total calories for "Protein Shake" equal to 240

