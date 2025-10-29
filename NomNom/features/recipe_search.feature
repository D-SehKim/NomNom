Feature: Search for different recipes on recipe search

  As a health focused user
  So that I can find good recipes
  I want to be able to search for recipes using one ingredient

  Background:
    Given I am logged in as a user

  Scenario: Searching for Chicken recipe
    Given I am on the recipe search page
    When I search for "chicken"
    Then I should see recipe results for "Brown Stew Chicken"
  
  Scenario: Searching for Non-Chicken recipe
    Given I am on the recipe search page
    When I search for "Salt"
    Then I should see recipe results for "Apam balik"
    And I should not see recipe results for "Brown Stew Chicken"

  Scenario: No results found for search
    Given I am on the recipe search page
    When I search for "xyz123nonexistent"
    Then I should see "No results found for"

  Scenario: Search with empty query
    Given I am on the recipe search page
    When I search for ""
    Then I should see "Search by ingredient:"