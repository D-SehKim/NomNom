Given('I am on the recipe search page') do
  visit recipes_path
end

When('I search for {string}') do |search_term|
  fill_in :ingredient, with: search_term
  click_button 'Search'
end

Then('I should see recipe results for {string}') do |search_term|
  expect(page).to have_content(search_term)
end

Then('I should not see recipe results for {string}') do |search_term|
  expect(page).not_to have_content(search_term)
end

Then('I should see at least one recipe containing {string}') do |ingredient|
  expect(page).to have_content(ingredient)
end