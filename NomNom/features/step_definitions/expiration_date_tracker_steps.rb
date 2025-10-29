Given('I am on the food tracker page') do
  visit items_path
end

When('I add a food item {string} with expiration date {string}') do |name, date|
  click_link 'Add Item'
  fill_in '🏷️ Item Name*', with: name
  fill_in '📅 Expiration Date*', with: date
  click_button 'Add Item'
end

Then('I should see {string} in my food tracker') do |food_name|
  expect(page).to have_content(food_name)
end

Then('I should see expiration date {string} for {string}') do |date, food_name|
  within("tr", text: food_name) do
    expect(page).to have_content(date)
  end
end

Given('I have the following food items:') do |table|
  table.hashes.each do |row|
    create(:item, 
      name: row['name'], 
      expires_at: row['expiration_date']
    )
  end
end

When('I delete {string}') do |food_name|
  within("tr", text: food_name) do
    click_link 'Delete'
  end
end

Then('I should not see {string} in my food tracker') do |food_name|
  expect(page).not_to have_content(food_name)
end

Given('I have a food item {string} with expiration date {string}') do |name, date|
  create(:item, name: name, expires_at: date)
end

Given('today is {string}') do |date|
  travel_to Date.parse(date)
end

Then('I should see {string} marked as expired') do |food_name|
  within("tr", text: food_name) do
    expect(page).to have_css('.status-expired')
  end
end

Then('I should see a warning {string}') do |warning_text|
  within('.alert, .warning, .notification') do
    expect(page).to have_content(warning_text)
  end
end

Then('I should see {string} with expiration date {string}') do |food_name, date|
  within("tr", text: food_name) do
    expect(page).to have_content(date)
  end
end