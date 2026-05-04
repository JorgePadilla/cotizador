require "test_helper"

class Settings::EstablishmentsControllerTest < ActionDispatch::IntegrationTest
  test "admin can create an establishment and lands on the fiscal tree" do
    sign_in_as(users(:admin_user))
    assert_difference("Establishment.count") do
      post settings_establishments_path, params: {
        establishment: { codigo: "002", nombre: "Sucursal", active: true }
      }
    end
    assert_redirected_to settings_fiscal_path
  end

  test "member is redirected" do
    sign_in_as(users(:member_user))
    get new_settings_establishment_path
    assert_redirected_to settings_root_path
  end
end
