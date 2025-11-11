Feature: Display list of all recipes and ingredients user has consumed

  As a health focused user
  So that I can quickly browse through everything I have eaten
  I want to see what meals, ingredients, and quantity of each that I have consumed

Scenario: Display list of all recipes
  Given I am logged in as a user
  And I have a meal with the recipe "Pancakes"
  And I have a meal with the recipe "Chocolate Cake"
  When I visit the calorie tracker page
  Then I should see "Pancakes" listed
  And I should see "Chocolate Cake" listed

Scenario: Display list of all custom ingredients
  Given I am logged in as a user
  And I have a custom ingredient "Sugar"
  And I have a custom ingredient "Salt"
  When I visit the calorie tracker page
  Then I should see "Sugar" listed
  And I should see "Salt" listed
