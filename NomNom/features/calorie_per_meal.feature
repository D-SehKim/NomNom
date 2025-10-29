Feature: Display how many calories in each meal and item

  As a health focused user
  So that I can keep track of my calorie intake
  I want to see calorie counts for each item and the total calorie count

Scenario: Viewing calories for a recipe meal
  Given I am logged in as a user
  And I have a meal with the recipe "Pancakes"
  When I visit the calorie tracker page
  Then I should see "Pancakes" listed
  And I should see the calories for each recipe ingredient
  And I should see the total calories for the recipe

Scenario: Viewing calories for a custom ingredient
  Given I am logged in as a user
  And I have a custom ingredient "Sugar"
  When I visit the calorie tracker page
  Then I should see "Sugar" listed
  And I should see the calories for the ingredient

Scenario: Viewing total calories consumed for custom ingredients
  Given I am logged in as a user
  And I have custom ingredients logged for today
  When I visit the calorie tracker page
  Then I should see the total calories consumed for custom ingredients

Scenario: Viewing total calories consumed for everything
  Given I am logged in as a user
  And I have meals logged for today
  When I visit the calorie tracker page
  Then I should see the total calories consumed for everything
