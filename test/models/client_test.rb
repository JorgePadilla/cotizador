require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "valid client" do
    organization = organizations(:default_organization)
    client = Client.new(
      name: "Test Client",
      rtn: "12345678",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com",
      organization: organization
    )
    assert client.valid?
  end

  test "client without name is invalid" do
    organization = organizations(:default_organization)
    client = Client.new(
      rtn: "12345678",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com",
      organization: organization
    )
    assert_not client.valid?
  end

  test "client without rtn is invalid" do
    organization = organizations(:default_organization)
    client = Client.new(
      name: "Test Client",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com",
      organization: organization
    )
    assert_not client.valid?
  end

  test "client with invalid email is invalid" do
    organization = organizations(:default_organization)
    client = Client.new(
      name: "Test Client",
      rtn: "12345678",
      address: "123 Test Street",
      phone: "555-1234",
      email: "invalid-email",
      organization: organization
    )
    assert_not client.valid?
  end

  test "client has many invoices" do
    client = Client.reflect_on_association(:invoices)
    assert_equal :has_many, client.macro
  end
end
