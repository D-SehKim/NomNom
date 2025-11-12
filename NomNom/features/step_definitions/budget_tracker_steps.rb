require 'bigdecimal'
require 'securerandom'

Given('I am logged in for budget tracking') do
  email = "budgeter_#{SecureRandom.hex(4)}@example.com"
  password = 'password123'
  @current_user = User.create!(email: email, password: password, password_confirmation: password)

  visit new_user_session_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

Given('I visit the budget tracker page') do
  visit budget_items_path
end

When('I fill in the budget form with:') do |table|
  fields = table.rows_hash
  fields.each do |key, value|
    field_id = "budget_item_#{key.downcase}"
    fill_in field_id, with: value
  end
end

When('I submit the budget form') do
  find('input[type="submit"]').click
end

Then('I should see {string} in the budget table') do |text|
  within('[data-testid="budget-table"]') do
    expect(page).to have_content(text)
  end
end

Then('the budget total should be {string}') do |expected_total|
  within('#budget-total') do
    expect(page).to have_content(expected_total)
  end
end

Given('the following budget entries exist:') do |table|
  table.hashes.each do |row|
    current_user = @current_user || User.first
    current_user ||= User.create!(email: "budgeter_#{SecureRandom.hex(4)}@example.com", password: 'password123', password_confirmation: 'password123')
    current_user.budget_items.create!(
      name: row['name'],
      amount: row['amount'].present? ? BigDecimal(row['amount'].to_s) : 0,
      notes: row['notes']
    )
  end
  visit budget_items_path
end

When('I edit the budget entry {string}') do |name|
  within('[data-testid="budget-table"]') do
    row = find('tr', text: name)
    row.click_link('Edit')
  end
end

When('I delete the budget entry {string}') do |name|
  within('[data-testid="budget-table"]') do
    row = find('tr', text: name)
    row.click_button('Delete')
  end
end

Then('I should see an empty budget tracker state') do
  expect(page).to have_content('No spending logged yet')
end

Then('I should see {string} field error') do |_field_label|
  expect(page).to have_content("Amount can't be blank")
end
