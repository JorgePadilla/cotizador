require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: {
        user: {
          email_address: "test@example.com",
          password: "password",
          password_confirmation: "password"
        },
        organization: {
          name: "Test Organization",
          currency: "USD"
        }
      }
    end
    assert_redirected_to root_url
  end
end
