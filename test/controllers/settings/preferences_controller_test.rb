require "test_helper"

class Settings::PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "show requires authentication" do
    get settings_preferences_path
    assert_redirected_to new_session_path
  end

  test "show renders the preferences page" do
    sign_in_as(users(:one))
    get settings_preferences_path
    assert_response :success
  end

  test "update applies language and currency" do
    sign_in_as(users(:one))
    patch settings_preferences_path, params: { user: { language: "es", currency: "HNL" } }
    assert_redirected_to settings_preferences_path
    user = users(:one).reload
    assert_equal "es",  user.language
    assert_equal "HNL", user.currency
  end

  test "non-admin user cannot update default_tax via preferences params" do
    sign_in_as(users(:member_user))
    original = users(:member_user).default_tax
    patch settings_preferences_path, params: { user: { language: "es", default_tax: 99 } }
    assert_equal original, users(:member_user).reload.default_tax
  end
end
