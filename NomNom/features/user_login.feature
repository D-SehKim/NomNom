Feature: User Login
  As a user
  So that I can access my personal data
  I want to be able to log in to my account

Background: users exist in database
  Given the following users exist:
  | email              | password   |
  | test@example.com   | password123 |

Scenario: Successful login with valid credentials
  Given I am on the login page
  When I fill in "Email" with "test@example.com"
  And I fill in "Password" with "password123"
  And I press "Log in"
  Then I should be on the home page
  And I should see "Signed in successfully"

Scenario: Failed login with invalid credentials
  Given I am on the login page
  When I fill in "Email" with "test@example.com"
  And I fill in "Password" with "wrongpassword"
  And I press "Log in"
  Then I should be on the login page
  And I should see "Invalid Email or password"

Scenario: Redirected to login when accessing protected page
  Given I am not logged in
  When I visit the grocery items page
  Then I should be on the login page
  And I should see "You need to sign in or sign up before continuing"
