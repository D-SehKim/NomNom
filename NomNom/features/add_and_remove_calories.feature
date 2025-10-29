Feature: Add and remove recipes/ingredients to count towards total calorie intake

	As a health focused user
	So that I can remember what I have eaten in the day
	I want to be able to add and remove items from my list

Background:
	Given I am logged in as a user
	And the following recipes exist:
		| name       | calories_per_serving |
		| Pancakes   | 300                 |
		| Omelette   | 250                 |
	And the following ingredients exist:
		| name    | calories_per_unit |
		| Sugar   | 50               |
		| Butter  | 100              |

Scenario: Adding a recipe to the calorie tracker
	When I add the recipe "Pancakes" with 2 servings
	Then I should see "Pancakes" listed
	And I should see total calories for "Pancakes" equal to 600

Scenario: Adding a custom ingredient to the calorie tracker
  When I add the custom ingredient "Sugar" with quantity 3
  Then I should see "Sugar" listed
  And I should see total calories for "Sugar" equal to 150

Scenario: Removing a recipe
	Given I have a meal with the recipe "Omelette" and 1 serving
	When I remove the recipe "Omelette"
	Then I should not see "Omelette" on the calorie tracker

Scenario: Removing a custom ingredient
	Given I have added a custom ingredient "Butter" with quantity 2
	When I remove the custom ingredient "Butter"
	Then I should not see "Butter" on the calorie tracker

Scenario: Total calories update correctly
  Given I have a meal with recipe "Pancakes" and 1 serving and custom ingredients:
    | name  | calories_per_unit | quantity |
    | Sugar | 50               | 2        |
  When I visit the calorie tracker page
  Then I should see total calories consumed equal to 400