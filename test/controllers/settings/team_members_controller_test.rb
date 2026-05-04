require "test_helper"

class Settings::TeamMembersControllerTest < ActionDispatch::IntegrationTest
  test "admin sees the team list" do
    sign_in_as(users(:admin_user))
    get settings_team_members_path
    assert_response :success
    assert_match users(:admin_user).email_address, response.body
  end

  test "member is redirected" do
    sign_in_as(users(:member_user))
    get settings_team_members_path
    assert_redirected_to settings_root_path
  end

  test "/admin/users redirects to /configuracion/team_members" do
    get "/admin/users"
    assert_redirected_to "/configuracion/team_members"
  end
end
