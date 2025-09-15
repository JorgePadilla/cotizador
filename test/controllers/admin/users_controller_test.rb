require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index when authenticated as admin" do
    sign_in_as(users(:admin_user))
    get admin_users_path
    assert_response :success
    assert_select "h1", "User Management"
    assert_select "table tbody tr", User.count
  end

  test "should get index when authenticated as owner" do
    sign_in_as(users(:one))
    get admin_users_path
    assert_response :success
    assert_select "h1", "User Management"
  end

  test "should redirect index when not authenticated as admin or owner" do
    sign_in_as(users(:member_user))
    get admin_users_path
    assert_redirected_to root_path
    assert_equal "You must be an admin to access this page.", flash[:alert]
  end

  test "should redirect index when not authenticated" do
    get admin_users_path
    assert_redirected_to new_session_path
  end

  test "should get edit when authenticated as admin for member user" do
    sign_in_as(users(:admin_user))
    user = users(:member_user)
    get edit_admin_user_path(user)
    assert_response :success
    assert_select "h1", "Edit User Role"
    assert_select "form"
  end

  test "should redirect edit when admin tries to edit own role" do
    admin = users(:admin_user)
    sign_in_as(admin)
    get edit_admin_user_path(admin)
    assert_redirected_to admin_users_path
    assert_equal "You cannot modify this user's role.", flash[:alert]
  end

  test "should redirect edit when admin tries to edit another admin" do
    sign_in_as(users(:admin_user))
    other_admin = users(:one) # user one is owner (role 0), let's make them admin
    other_admin.update!(role: 1)
    get edit_admin_user_path(other_admin)
    assert_redirected_to admin_users_path
    assert_equal "You cannot modify this user's role.", flash[:alert]
  end

  test "should redirect edit when admin tries to edit owner" do
    sign_in_as(users(:admin_user))
    owner = users(:one)
    get edit_admin_user_path(owner)
    assert_redirected_to admin_users_path
    assert_equal "You cannot modify this user's role.", flash[:alert]
  end

  test "should update user role when authenticated as admin for member user" do
    sign_in_as(users(:admin_user))
    user = users(:member_user)
    patch admin_user_path(user), params: { user: { role: 1 } }
    assert_redirected_to admin_users_path
    assert_equal "User role updated successfully.", flash[:notice]
    assert_equal 1, user.reload.role
  end

  test "should redirect update when admin tries to update own role" do
    admin = users(:admin_user)
    sign_in_as(admin)
    patch admin_user_path(admin), params: { user: { role: 2 } }
    assert_redirected_to admin_users_path
    assert_equal "You cannot modify this user's role.", flash[:alert]
    assert_equal 1, admin.reload.role # Role should not change
  end

  test "should redirect update when admin tries to update another admin" do
    sign_in_as(users(:admin_user))
    other_admin = users(:one)
    other_admin.update!(role: 1)
    patch admin_user_path(other_admin), params: { user: { role: 2 } }
    assert_redirected_to admin_users_path
    assert_equal "You cannot modify this user's role.", flash[:alert]
    assert_equal 1, other_admin.reload.role # Role should not change
  end

  test "should redirect update when admin tries to update owner" do
    sign_in_as(users(:admin_user))
    owner = users(:one)
    patch admin_user_path(owner), params: { user: { role: 2 } }
    assert_redirected_to admin_users_path
    assert_equal "You cannot modify this user's role.", flash[:alert]
    assert_equal 0, owner.reload.role # Role should not change
  end

  test "should allow owner to update admin role" do
    sign_in_as(users(:one)) # user one is owner
    admin = users(:admin_user)
    patch admin_user_path(admin), params: { user: { role: 2 } }
    assert_redirected_to admin_users_path
    assert_equal "User role updated successfully.", flash[:notice]
    assert_equal 2, admin.reload.role # Role should change
  end

  test "should allow owner to update own role" do
    owner = users(:one)
    sign_in_as(owner)
    patch admin_user_path(owner), params: { user: { role: 1 } }
    assert_redirected_to admin_users_path
    assert_equal "User role updated successfully.", flash[:notice]
    assert_equal 1, owner.reload.role # Role should change
  end

  test "should render edit when update fails" do
    sign_in_as(users(:admin_user))
    user = users(:two)
    patch admin_user_path(user), params: { user: { role: 99 } }
    assert_response :unprocessable_entity
    assert_select "h1", "Edit User Role"
  end

  test "should redirect edit when not authenticated as admin or owner" do
    sign_in_as(users(:member_user))
    user = users(:two)
    get edit_admin_user_path(user)
    assert_redirected_to root_path
    assert_equal "You must be an admin to access this page.", flash[:alert]
  end

  test "should redirect update when not authenticated as admin or owner" do
    sign_in_as(users(:member_user))
    user = users(:two)
    patch admin_user_path(user), params: { user: { role: 1 } }
    assert_redirected_to root_path
    assert_equal "You must be an admin to access this page.", flash[:alert]
    assert_equal 2, user.reload.role
  end
end
