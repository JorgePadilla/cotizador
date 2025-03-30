require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "valid client" do
    client = Client.new(
      name: "Test Client",
      rtn: "12345678",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com"
    )
    assert client.valid?
  end

  test "client without name is invalid" do
    client = Client.new(
      rtn: "12345678",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com"
    )
    assert_not client.valid?
  end

  test "client without rtn is invalid" do
    client = Client.new(
      name: "Test Client",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com"
    )
    assert_not client.valid?
  end

  test "client with invalid email is invalid" do
    client = Client.new(
      name: "Test Client",
      rtn: "12345678",
      address: "123 Test Street",
      phone: "555-1234",
      email: "invalid-email"
    )
    assert_not client.valid?
  end

  test "client has many invoices" do
    client = Client.reflect_on_association(:invoices)
    assert_equal :has_many, client.macro
  end
end
