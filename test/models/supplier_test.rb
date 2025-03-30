require "test_helper"

class SupplierTest < ActiveSupport::TestCase
  test "valid supplier" do
    supplier = Supplier.new(
      name: "Test Supplier",
      rtn: "87654321",
      contact_name: "Contact Person",
      phone: "555-5678",
      email: "supplier@example.com"
    )
    assert supplier.valid?
  end

  test "supplier without name is invalid" do
    supplier = Supplier.new(
      rtn: "87654321",
      contact_name: "Contact Person",
      phone: "555-5678",
      email: "supplier@example.com"
    )
    assert_not supplier.valid?
  end

  test "supplier without rtn is invalid" do
    supplier = Supplier.new(
      name: "Test Supplier",
      contact_name: "Contact Person",
      phone: "555-5678",
      email: "supplier@example.com"
    )
    assert_not supplier.valid?
  end

  test "supplier with invalid email is invalid" do
    supplier = Supplier.new(
      name: "Test Supplier",
      rtn: "87654321",
      contact_name: "Contact Person",
      phone: "555-5678",
      email: "invalid-email"
    )
    assert_not supplier.valid?
  end

  test "supplier has many products" do
    supplier = Supplier.reflect_on_association(:products)
    assert_equal :has_many, supplier.macro
  end
end
