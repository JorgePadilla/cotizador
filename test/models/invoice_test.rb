require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "valid invoice" do
    client = clients(:one)
    invoice = Invoice.new(
      invoice_number: "INV001",
      client: client,
      subtotal: 100.00,
      tax: 15.00,
      total: 115.00,
      status: "pending",
      payment_method: "cash"
    )
    assert invoice.valid?
  end

  test "invoice without invoice_number is invalid" do
    client = clients(:one)
    invoice = Invoice.new(
      client: client,
      subtotal: 100.00,
      tax: 15.00,
      total: 115.00,
      status: "pending",
      payment_method: "cash"
    )
    assert_not invoice.valid?
  end

  test "invoice without client is invalid" do
    invoice = Invoice.new(
      invoice_number: "INV001",
      subtotal: 100.00,
      tax: 15.00,
      total: 115.00,
      status: "pending",
      payment_method: "cash"
    )
    assert_not invoice.valid?
  end

  test "invoice with negative total is invalid" do
    client = clients(:one)
    invoice = Invoice.new(
      invoice_number: "INV001",
      client: client,
      subtotal: 100.00,
      tax: 15.00,
      total: -10.00,
      status: "pending",
      payment_method: "cash"
    )
    assert_not invoice.valid?
  end

  test "invoice belongs to client" do
    invoice = Invoice.reflect_on_association(:client)
    assert_equal :belongs_to, invoice.macro
  end

  test "invoice has many invoice_items" do
    invoice = Invoice.reflect_on_association(:invoice_items)
    assert_equal :has_many, invoice.macro
  end
end
