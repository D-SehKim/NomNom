# Login step definitions for Cucumber tests
require 'rspec/expectations'

Given(/^the following users exist:$/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(
      email: user['email'],
      password: user['password'],
      password_confirmation: user['password']
    )
  end
end

Given(/^I am on the login page$/) do
  visit new_user_session_path
end

Given(/^I am not logged in$/) do
  # Ensure user is logged out by visiting logout path
  page.driver.submit :delete, destroy_user_session_path, {}
  # Also clear any existing session
  Capybara.reset_sessions!
end

When(/^I visit the grocery items page$/) do
  visit grocery_items_path
end

# Then(/^I should be on the home page$/) do
#   expect(current_path).to eq(root_path)
# end

Then(/^I should be on the login page$/) do
  expect(current_path).to eq(new_user_session_path)
end

# Then(/^I should see "([^"]*)"$/) do |text|
#   expect(page).to have_content(text)
# end

# Then(/^I should not see "([^"]*)"$/) do |text|
#   expect(page).not_to have_content(text)
# end

# When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
#   fill_in field, with: value
# end

When(/^I press "([^"]*)"$/) do |button|
  click_button button
end
