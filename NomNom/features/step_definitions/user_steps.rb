Given("I am logged in as a user") do
  @user = User.find_or_create_by!(email: "test@nomnom.com") do |u|
    u.password = "password"
    u.password_confirmation = "password"
  end

  visit new_user_session_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: "password"
  click_button "Log in"
end