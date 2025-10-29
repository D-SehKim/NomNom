# Grocery List Step Definitions

Given(/^I am a registered user$/) do
  @user = User.create!(
    email: 'test@example.com',
    password: 'password123',
    password_confirmation: 'password123'
  )
end

Given(/^I am signed in$/) do
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

Given(/^I am on the grocery list page$/) do
  visit grocery_items_path
end

When(/^I click "([^"]*)"$/) do |button_text|
  click_link_or_button button_text
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, with: value
end

When(/^I leave "([^"]*)" empty$/) do |field|
  fill_in field, with: ''
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_content(text)
end

Given(/^I have the following items in my grocery list:$/) do |table|
  table.hashes.each do |item_hash|
    @user.grocery_items.create!(
      name: item_hash['name'],
      quantity: item_hash['quantity'],
      purchased: item_hash['purchased'] == 'true',
      notes: item_hash['notes']
    )
  end
  visit grocery_items_path
end

When(/^I click "([^"]*)" for "([^"]*)"$/) do |action, item_name|
  item = @user.grocery_items.find_by(name: item_name)
  
  case action
  when "Mark Purchased", "✓ Purchased"
    within("tr", text: item_name) do
      click_button "✓ Purchased"
    end
  when "Undo", "↩️ Undo"
    within("tr", text: item_name) do
      click_button "↩️ Undo"
    end
  when "Edit", "✏️ Edit"
    within("tr", text: item_name) do
      click_link "✏️ Edit"
    end
  when "Delete", "🗑️ Delete"
    within("tr", text: item_name) do
      click_button "🗑️ Delete"
    end
  end
end

When(/^I confirm the deletion$/) do
  page.driver.browser.switch_to.alert.accept if page.driver.browser.respond_to?(:switch_to)
end

Then(/^I should see "([^"]*)" in the "([^"]*)" section$/) do |item_name, section|
  case section
  when "To Buy"
    within('.to-buy-section, [data-testid="to-buy-section"]') do
      expect(page).to have_content(item_name)
    end
  when "Purchased"
    within('.purchased-section, [data-testid="purchased-section"]') do
      expect(page).to have_content(item_name)
    end
  end
end

Then(/^I should not see "([^"]*)" in the "([^"]*)" section$/) do |item_name, section|
  case section
  when "To Buy"
    if page.has_css?('.to-buy-section, [data-testid="to-buy-section"]')
      within('.to-buy-section, [data-testid="to-buy-section"]') do
        expect(page).not_to have_content(item_name)
      end
    end
  when "Purchased"
    if page.has_css?('.purchased-section, [data-testid="purchased-section"]')
      within('.purchased-section, [data-testid="purchased-section"]') do
        expect(page).not_to have_content(item_name)
      end
    end
  end
end

Then(/^I should see "([^"]*)" next to "([^"]*)"$/) do |quantity, item_name|
  within("tr", text: item_name) do
    expect(page).to have_content(quantity)
  end
end

Given(/^I have no items in my grocery list$/) do
  @user.grocery_items.destroy_all
  visit grocery_items_path
end

Then(/^I should see a link to "([^"]*)"$/) do |link_text|
  expect(page).to have_link(link_text)
end

Then(/^I should see "([^"]*)" in the notes column for "([^"]*)"$/) do |notes_content, item_name|
  within("tr", text: item_name) do
    expect(page).to have_content(notes_content)
  end
end

Then(/^the item should not be added to my grocery list$/) do
  # Check that we're still on the new/create page (not redirected)
  expect(current_path).not_to eq(new_grocery_item_path)
end

Given(/^another user "([^"]*)" has the following items in their grocery list:$/) do |email, table|
  other_user = User.create!(
    email: email,
    password: 'password123',
    password_confirmation: 'password123'
  )
  
  table.hashes.each do |item_hash|
    other_user.grocery_items.create!(
      name: item_hash['name'],
      quantity: item_hash['quantity'],
      purchased: item_hash['purchased'] == 'true'
    )
  end
end

Then(/^I should not see "([^"]*)" in my grocery list$/) do |item_name|
  expect(page).not_to have_content(item_name)
end

Then(/^I should be on the home page$/) do
  expect(current_path).to eq(root_path)
end

Then(/^I should see "([^"]*)" section header$/) do |header_text|
  expect(page).to have_content(header_text)
end

# Helper step for debugging
Then(/^show me the page$/) do
  save_and_open_page
end

# Background steps that may be called from other features
# Given(/^I am logged in as a user$/) do
#   step 'I am a registered user'
#   step 'I am signed in'
# end
