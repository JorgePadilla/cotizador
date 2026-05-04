require "test_helper"

class Sar::CaiAuthorizationsControllerTest < ActionDispatch::IntegrationTest
  test "admin can list CAI authorizations" do
    sign_in_as(users(:admin_user))
    get sar_cai_authorizations_path
    assert_response :success
    assert_match cai_authorizations(:factura_active).cai, response.body
  end

  test "destroy is blocked when CAI has issued documents" do
    cai_authorizations(:factura_active).update_columns(correlativo_actual: 1)
    sign_in_as(users(:admin_user))
    assert_no_difference("CaiAuthorization.count") do
      delete sar_cai_authorization_path(cai_authorizations(:factura_active))
    end
    assert_redirected_to sar_cai_authorization_path(cai_authorizations(:factura_active))
  end

  test "non-admin is redirected" do
    sign_in_as(users(:member_user))
    get sar_cai_authorizations_path
    assert_redirected_to root_path
  end
end
