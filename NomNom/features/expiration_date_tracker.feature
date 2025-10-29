Feature: Track expiration dates for food

  As a user who is worried about food waste
  So that I don't waste future food or forget about it
  I want to be able to track expiration dates for food

  Background:
    Given I am logged in as a user

  Scenario: Add food item with expiration date
    Given I am on the food tracker page
    When I add a food item "Milk" with expiration date "2025-11-05"
    Then I should see "Milk" in my food tracker
    And I should see expiration date "November 05, 2025" for "Milk"

  Scenario: View all tracked food items
    Given I have the following food items:
      | name    | expiration_date |
      | Milk    | 2025-11-05     |
      | Eggs    | 2025-11-10     |
      | Cheese  | 2025-11-15     |
    When I am on the food tracker page
    Then I should see "Milk" with expiration date "November 05, 2025"
    And I should see "Eggs" with expiration date "November 10, 2025"
    And I should see "Cheese" with expiration date "November 15, 2025"

  Scenario: Delete expired food item
    Given I have a food item "Old Bread" with expiration date "2025-10-20"
    And I am on the food tracker page
    When I delete "Old Bread"
    Then I should not see "Old Bread" in my food tracker

  Scenario: View expired items
    Given I have the following food items:
      | name        | expiration_date |
      | Old Milk    | 2025-10-20     |
      | Fresh Eggs  | 2025-11-15     |
      | Old Bread   | 2025-10-25     |
    And today is "2025-10-29"
    When I am on the food tracker page
    Then I should see "Old Milk" marked as expired
    And I should see "Old Bread" marked as expired