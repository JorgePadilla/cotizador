require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "valid client" do
    organization = organizations(:default_organization)
    client = Client.new(
      name: "Test Client",
      rtn: "08019999000099",
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
      rtn: "08019999000099",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com",
      organization: organization
    )
    assert_not client.valid?
  end

  test "client without rtn is valid" do
    organization = organizations(:default_organization)
    client = Client.new(
      name: "Test Client",
      address: "123 Test Street",
      phone: "555-1234",
      email: "test@example.com",
      organization: organization
    )
    assert client.valid?
  end

  test "client with duplicate rtn in same organization is invalid" do
    organization = organizations(:default_organization)
    client1 = Client.create!(
      name: "Client 1",
      rtn: "08019999000099",
      organization: organization
    )
    client2 = Client.new(
      name: "Client 2",
      rtn: "08019999000099",
      organization: organization
    )
    assert_not client2.valid?
  end

  test "client with blank rtn is valid even if other clients have blank rtn" do
    organization = organizations(:default_organization)
    client1 = Client.create!(
      name: "Client 1",
      rtn: "",
      organization: organization
    )
    client2 = Client.new(
      name: "Client 2",
      rtn: "",
      organization: organization
    )
    assert client2.valid?
  end

  test "client with invalid email is invalid" do
    organization = organizations(:default_organization)
    client = Client.new(
      name: "Test Client",
      rtn: "08019999000099",
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
