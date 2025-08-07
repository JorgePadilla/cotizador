require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    login_as(@user)
  end

  test "should get show" do
    get profile_url
    assert_response :success
  end

  test "should get edit" do
    get profile_edit_url
    assert_response :success
  end

  test "should update profile" do
    patch profile_url, params: { user: { name: "New Name", email_address: @user.email_address, language: "en" } }
    assert_redirected_to profile_url
    @user.reload
    assert_equal "New Name", @user.name
  end

  test "should update default_tax" do
    patch profile_url, params: { user: { default_tax: 0.2 } }
    assert_redirected_to profile_url
    @user.reload
    assert_equal 0.2, @user.default_tax
  end

  test "should update language" do
    patch profile_language_url, params: { user: { language: "es" } }
    assert_redirected_to profile_url
    @user.reload
    assert_equal "es", @user.language
  end
end
