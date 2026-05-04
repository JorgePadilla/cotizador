require "test_helper"

class Settings::FiscalControllerTest < ActionDispatch::IntegrationTest
  test "admin sees the fiscal tree with seeded establishment" do
    sign_in_as(users(:admin_user))
    get settings_fiscal_path
    assert_response :success
    assert_match establishments(:main).codigo, response.body
    assert_match cai_authorizations(:factura_active).cai[0, 10], response.body
  end

  test "member is redirected" do
    sign_in_as(users(:member_user))
    get settings_fiscal_path
    assert_redirected_to settings_root_path
  end

  test "/configuracion-fiscal redirects to /configuracion/fiscal" do
    get "/configuracion-fiscal"
    assert_redirected_to "/configuracion/fiscal"
  end
end
