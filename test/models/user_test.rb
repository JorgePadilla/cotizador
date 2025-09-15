require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "default_tax should be valid within range" do
    user = users(:one)

    # Valid values
    user.default_tax = 0
    assert user.valid?, "Default tax of 0 should be valid"

    user.default_tax = 15
    assert user.valid?, "Default tax of 15 should be valid"

    user.default_tax = 100
    assert user.valid?, "Default tax of 100 should be valid"

    # Invalid values
    user.default_tax = -1
    assert_not user.valid?, "Default tax below 0 should be invalid"

    user.default_tax = 101
    assert_not user.valid?, "Default tax above 100 should be invalid"
  end

  test "default_tax should default to 15" do
    user = User.new
    assert_equal 15, user.default_tax, "Default tax should be 15 for new users"
  end
end
