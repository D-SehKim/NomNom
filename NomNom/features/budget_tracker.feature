Feature: Budget Tracker
  As a budget-conscious NomNom user
  So that I can keep track of my grocery spending
  I want to log and manage how much I spend on each purchase

  Background:
    Given I am logged in for budget tracking
    And I visit the budget tracker page

  Scenario: Add a new budget entry
    When I click "➕ Add Budget Entry"
    And I fill in the budget form with:
      | name   | Fresh Berries |
      | amount | 12.50 |
      | notes  | Farmers market |
    And I submit the budget form
    Then I should see "Budget item added successfully."
    And I should see "Fresh Berries" in the budget table
    And I should see "$12.50" in the budget table
    And the budget total should be "$12.50"

  Scenario: Edit an existing budget entry
    Given the following budget entries exist:
      | name         | amount | notes         |
      | Weekly Meat  | 45.00  | Costco run    |
    When I edit the budget entry "Weekly Meat"
    And I fill in the budget form with:
      | amount | 52.25 |
      | notes  | Added steak |
    And I submit the budget form
    Then I should see "Budget item updated successfully."
    And I should see "$52.25" in the budget table
    And the budget total should be "$52.25"

  Scenario: Delete a budget entry
    Given the following budget entries exist:
      | name         | amount | notes        |
      | Impulse Buy  | 9.99   | Chocolate    |
    When I delete the budget entry "Impulse Buy"
    Then I should see "Budget item removed."
    And I should see an empty budget tracker state

  Scenario: Amount is required
    When I click "➕ Add Budget Entry"
    And I fill in the budget form with:
      | name | Produce haul |
    And I submit the budget form
    Then I should see "Amount Spent*" field error

  Scenario: Budget total reflects multiple entries
    Given the following budget entries exist:
      | name        | amount | notes |
      | Produce     | 20.00  |      |
      | Pantry restock | 15.50 | |
    Then the budget total should be "$35.50"
