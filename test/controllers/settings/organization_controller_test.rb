require "test_helper"

class Settings::OrganizationControllerTest < ActionDispatch::IntegrationTest
  test "show renders for any authenticated user" do
    sign_in_as(users(:member_user))
    get settings_organization_path
    assert_response :success
    assert_match organizations(:default_organization).name, response.body
  end

  test "edit blocked for member-role users" do
    sign_in_as(users(:member_user))
    get edit_settings_organization_path
    assert_redirected_to settings_root_path
  end

  test "admin can update organization" do
    sign_in_as(users(:admin_user))
    patch settings_organization_path, params: { organization: { nombre_comercial: "Updated Trade Name" } }
    assert_redirected_to settings_organization_path
    assert_equal "Updated Trade Name", organizations(:default_organization).reload.nombre_comercial
  end
end
