require "test_helper"
require "pdf/inspector"
require_relative "../../app/pdfs/invoice_pdf"

class InvoicePdfTest < ActiveSupport::TestCase
  test "fiscal invoice PDF contains CAI, correlativo, total a pagar, and mandatory legend" do
    invoice = Invoice.create!(
      organization: organizations(:default_organization),
      client: clients(:one),
      establishment: establishments(:main),
      emission_point: emission_points(:main),
      document_type: document_types(:factura),
      cai_authorization: cai_authorizations(:factura_active),
      invoice_items_attributes: [
        { product_id: products(:one).id, quantity: 1, unit_price: 100, description: "Test" }
      ]
    )

    pdf_data = InvoicePdf.new(invoice, :es).render
    text = PDF::Inspector::Text.analyze(pdf_data).strings.join(" ")

    assert_includes text, invoice.cai_authorization.cai[0, 25]
    assert_includes text, invoice.correlativo
    assert_includes text, "Total a pagar"
    assert_includes text, "La factura es beneficio de todos"
    assert_includes text, "FACTURA"
  end

  test "legacy invoice PDF still renders without SAR fields" do
    pdf_data = InvoicePdf.new(invoices(:one), :en).render
    text = PDF::Inspector::Text.analyze(pdf_data).strings.join(" ")
    assert_includes text, "INVOICE"
  end
end
