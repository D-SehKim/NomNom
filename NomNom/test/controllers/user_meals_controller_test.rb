require "test_helper"

class UserMealsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_meals_index_url
    assert_response :success
  end

  test "should get new" do
    get user_meals_new_url
    assert_response :success
  end

  test "should get create" do
    get user_meals_create_url
    assert_response :success
  end
end
