require "test_helper"

class Sar::EstablishmentsControllerTest < ActionDispatch::IntegrationTest
  test "admin sees the list" do
    sign_in_as(users(:admin_user))
    get sar_establishments_path
    assert_response :success
    assert_match establishments(:main).codigo, response.body
  end

  test "non-admin is redirected" do
    sign_in_as(users(:member_user))
    get sar_establishments_path
    assert_redirected_to root_path
  end

  test "unauthenticated is redirected to sign-in" do
    get sar_establishments_path
    assert_redirected_to new_session_path
  end

  test "admin can create an establishment" do
    sign_in_as(users(:admin_user))
    assert_difference("Establishment.count") do
      post sar_establishments_path, params: {
        establishment: { codigo: "002", nombre: "Sucursal", address: "Av. La Paz", phone: "+504 9999-0000", active: true }
      }
    end
    new_est = Establishment.find_by(codigo: "002")
    assert_redirected_to sar_establishment_path(new_est)
  end

  test "admin can update an establishment" do
    sign_in_as(users(:admin_user))
    patch sar_establishment_path(establishments(:main)), params: { establishment: { nombre: "Casa Matriz Renamed" } }
    assert_redirected_to sar_establishment_path(establishments(:main))
    assert_equal "Casa Matriz Renamed", establishments(:main).reload.nombre
  end
end
