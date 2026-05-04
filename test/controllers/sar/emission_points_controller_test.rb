require "test_helper"

class Sar::EmissionPointsControllerTest < ActionDispatch::IntegrationTest
  setup { @establishment = establishments(:main) }

  test "admin can create an emission point" do
    sign_in_as(users(:admin_user))
    assert_difference("EmissionPoint.count") do
      post sar_establishment_emission_points_path(@establishment),
           params: { emission_point: { codigo: "002", descripcion: "Caja 2", active: true } }
    end
  end

  test "non-admin is redirected" do
    sign_in_as(users(:member_user))
    get new_sar_establishment_emission_point_path(@establishment)
    assert_redirected_to root_path
  end
end
