require "test_helper"

class Settings::AccountsControllerTest < ActionDispatch::IntegrationTest
  test "show requires authentication" do
    get settings_account_path
    assert_redirected_to new_session_path
  end

  test "authenticated user sees their account" do
    sign_in_as(users(:one))
    get settings_account_path
    assert_response :success
    assert_match users(:one).email_address, response.body
  end

  test "update changes name and email" do
    sign_in_as(users(:one))
    patch settings_account_path, params: { user: { name: "New Name", email_address: "new@example.com" } }
    assert_redirected_to settings_account_path
    assert_equal "New Name", users(:one).reload.name
  end

  test "/profile redirects to /configuracion/account" do
    get "/profile"
    assert_redirected_to "/configuracion/account"
  end
end
