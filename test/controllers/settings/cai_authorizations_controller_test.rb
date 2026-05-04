require "test_helper"

class Settings::CaiAuthorizationsControllerTest < ActionDispatch::IntegrationTest
  test "admin sees new form with emission_point preselected from query" do
    sign_in_as(users(:admin_user))
    get new_settings_cai_authorization_path(emission_point_id: emission_points(:main).id)
    assert_response :success
  end

  test "destroy is blocked when CAI has issued documents" do
    cai_authorizations(:factura_active).update_columns(correlativo_actual: 1)
    sign_in_as(users(:admin_user))
    assert_no_difference("CaiAuthorization.count") do
      delete settings_cai_authorization_path(cai_authorizations(:factura_active))
    end
    assert_redirected_to settings_fiscal_path
  end

  test "member is redirected" do
    sign_in_as(users(:member_user))
    get new_settings_cai_authorization_path
    assert_redirected_to settings_root_path
  end
end
