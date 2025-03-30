require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "valid product" do
    supplier = suppliers(:one)
    product = Product.new(
      name: "Test Product",
      sku: "PROD001",
      description: "This is a test product",
      price: 100.00,
      cost: 50.00,
      stock: 10,
      supplier: supplier
    )
    assert product.valid?
  end

  test "product without name is invalid" do
    supplier = suppliers(:one)
    product = Product.new(
      sku: "PROD001",
      description: "This is a test product",
      price: 100.00,
      cost: 50.00,
      stock: 10,
      supplier: supplier
    )
    assert_not product.valid?
  end

  test "product without sku is invalid" do
    supplier = suppliers(:one)
    product = Product.new(
      name: "Test Product",
      description: "This is a test product",
      price: 100.00,
      cost: 50.00,
      stock: 10,
      supplier: supplier
    )
    assert_not product.valid?
  end

  test "product without price is invalid" do
    supplier = suppliers(:one)
    product = Product.new(
      name: "Test Product",
      sku: "PROD001",
      description: "This is a test product",
      cost: 50.00,
      stock: 10,
      supplier: supplier
    )
    assert_not product.valid?
  end

  test "product belongs to supplier" do
    product = Product.reflect_on_association(:supplier)
    assert_equal :belongs_to, product.macro
  end

  test "product has many invoice_items" do
    product = Product.reflect_on_association(:invoice_items)
    assert_equal :has_many, product.macro
  end
end
