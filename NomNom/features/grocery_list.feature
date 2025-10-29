Feature: Grocery List Management
  As a NomNom user
  So that I can plan my grocery shopping efficiently
  I want to create, manage, and track my grocery list items

  Background:
    Given I am a registered user
    And I am signed in
    And I am on the grocery list page

  @grocery_list @core_feature
  Scenario: Add a new item to grocery list
    When I click "Add Item"
    And I fill in "Item Name" with "Organic Milk"
    And I fill in "Quantity" with "2L"
    And I fill in "Notes" with "Low fat preferred"
    And I click "Add to Grocery List"
    Then I should see "Item added to grocery list successfully"
    And I should see "Organic Milk" in the "To Buy" section
    And I should see "2L" next to "Organic Milk"

  @grocery_list @core_feature
  Scenario: Mark item as purchased
    Given I have the following items in my grocery list:
      | name          | quantity | purchased |
      | Fresh Apples  | 2kg      | false     |
      | Whole Bread   | 1 loaf   | false     |
    When I click "Mark Purchased" for "Fresh Apples"
    Then I should see "Fresh Apples" in the "Purchased" section
    And I should not see "Fresh Apples" in the "To Buy" section
    And "Fresh Apples" should appear crossed out

  @grocery_list @core_feature
  Scenario: Undo purchased item
    Given I have the following items in my grocery list:
      | name          | quantity | purchased |
      | Greek Yogurt  | 500g     | true      |
    When I click "Undo" for "Greek Yogurt"
    Then I should see "Greek Yogurt" in the "To Buy" section
    And I should not see "Greek Yogurt" in the "Purchased" section
    And "Greek Yogurt" should not appear crossed out

  @grocery_list @core_feature
  Scenario: Edit grocery list item
    Given I have the following items in my grocery list:
      | name         | quantity | notes              | purchased |
      | Orange Juice | 1L       | Pulp free please   | false     |
    When I click "Edit" for "Orange Juice"
    And I fill in "Item Name" with "Fresh Orange Juice"
    And I fill in "Quantity" with "2L"
    And I fill in "Notes" with "With pulp is fine"
    And I click "Update Item"
    Then I should see "Item updated successfully"
    And I should see "Fresh Orange Juice" in the "To Buy" section
    And I should see "2L" next to "Fresh Orange Juice"

  @grocery_list @core_feature
  Scenario: Delete item from grocery list
    Given I have the following items in my grocery list:
      | name         | quantity | purchased |
      | Expired Milk | 1L       | false     |
    When I click "Delete" for "Expired Milk"
    And I confirm the deletion
    Then I should see "Item removed from grocery list"
    And I should not see "Expired Milk" in my grocery list

  @grocery_list
  Scenario: View separate purchased and unpurchased items
    Given I have the following items in my grocery list:
      | name          | quantity | purchased |
      | Bananas       | 1 bunch  | false     |
      | Strawberries  | 500g     | false     |
      | Carrots       | 1kg      | true      |
      | Onions        | 2kg      | true      |
    Then I should see "To Buy (2)" section header
    And I should see "Purchased (2)" section header
    And I should see "Bananas" in the "To Buy" section
    And I should see "Strawberries" in the "To Buy" section
    And I should see "Carrots" in the "Purchased" section
    And I should see "Onions" in the "Purchased" section

  @grocery_list
  Scenario: Empty grocery list state
    Given I have no items in my grocery list
    Then I should see "Your grocery list is empty"
    And I should see "Start by adding items you need to buy!"
    And I should see a link to "Add Your First Item"

  @grocery_list
  Scenario: Add item without notes
    When I click "Add Item"
    And I fill in "Item Name" with "Rice"
    And I fill in "Quantity" with "5kg"
    And I leave "Notes" empty
    And I click "Add to Grocery List"
    Then I should see "Item added to grocery list successfully"
    And I should see "Rice" in the "To Buy" section
    And I should see "-" in the notes column for "Rice"

  @grocery_list @validation
  Scenario: Cannot add item without name
    When I click "Add Item"
    And I leave "Item Name" empty
    And I fill in "Quantity" with "1"
    And I click "Add to Grocery List"
    Then I should see "Name can't be blank"
    And the item should not be added to my grocery list

  @grocery_list @validation
  Scenario: Cannot add item without quantity
    When I click "Add Item"
    And I fill in "Item Name" with "Sugar"
    And I leave "Quantity" empty
    And I click "Add to Grocery List"
    Then I should see "Quantity can't be blank"
    And the item should not be added to my grocery list

  @grocery_list @user_isolation
  Scenario: Users can only see their own grocery lists
    Given another user "john@example.com" has the following items in their grocery list:
      | name     | quantity | purchased |
      | Pasta    | 500g     | false     |
      | Tomatoes | 1kg      | true      |
    When I am on the grocery list page
    Then I should not see "Pasta" in my grocery list
    And I should not see "Tomatoes" in my grocery list

  @grocery_list @navigation
  Scenario: Navigate back to home from grocery list
    When I click "Back to Home"
    Then I should be on the home page
    And I should see "Welcome to NomNom"
