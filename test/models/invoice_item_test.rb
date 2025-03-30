require "test_helper"

class InvoiceItemTest < ActiveSupport::TestCase
  test "valid invoice_item" do
    invoice = invoices(:one)
    product = products(:one)
    invoice_item = InvoiceItem.new(
      invoice: invoice,
      product: product,
      description: "Test item",
      quantity: 2,
      unit_price: 50.00,
      total: 100.00
    )
    assert invoice_item.valid?
  end

  test "invoice_item without invoice is invalid" do
    product = products(:one)
    invoice_item = InvoiceItem.new(
      product: product,
      description: "Test item",
      quantity: 2,
      unit_price: 50.00,
      total: 100.00
    )
    assert_not invoice_item.valid?
  end

  test "invoice_item without product is invalid" do
    invoice = invoices(:one)
    invoice_item = InvoiceItem.new(
      invoice: invoice,
      description: "Test item",
      quantity: 2,
      unit_price: 50.00,
      total: 100.00
    )
    assert_not invoice_item.valid?
  end

  test "invoice_item without quantity is invalid" do
    invoice = invoices(:one)
    product = products(:one)
    invoice_item = InvoiceItem.new(
      invoice: invoice,
      product: product,
      description: "Test item",
      unit_price: 50.00,
      total: 100.00
    )
    assert_not invoice_item.valid?
  end

  test "invoice_item without unit_price is invalid" do
    invoice = invoices(:one)
    product = products(:one)
    invoice_item = InvoiceItem.new(
      invoice: invoice,
      product: product,
      description: "Test item",
      quantity: 2,
      total: 100.00
    )
    assert_not invoice_item.valid?
  end

  test "invoice_item belongs to invoice" do
    invoice_item = InvoiceItem.reflect_on_association(:invoice)
    assert_equal :belongs_to, invoice_item.macro
  end

  test "invoice_item belongs to product" do
    invoice_item = InvoiceItem.reflect_on_association(:product)
    assert_equal :belongs_to, invoice_item.macro
  end
end
