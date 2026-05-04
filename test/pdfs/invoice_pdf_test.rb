require "test_helper"
require "pdf/inspector"
require_relative "../../app/pdfs/invoice_pdf"

class InvoicePdfTest < ActiveSupport::TestCase
  test "fiscal invoice PDF includes all SAR-required fields and renders ORIGINAL + COPIA" do
    org = organizations(:default_organization)
    org.update!(phone: "+504 2222-3333", email: "factura@miempresa.com")
    invoice = Invoice.create!(
      organization: org,
      client: clients(:one),
      establishment: establishments(:main),
      emission_point: emission_points(:main),
      document_type: document_types(:factura),
      cai_authorization: cai_authorizations(:factura_active),
      payment_method: "cash",
      invoice_items_attributes: [
        { product_id: products(:one).id, quantity: 2, unit_price: 100, description: "Test" }
      ]
    )

    pdf_data = InvoicePdf.new(invoice, :es).render
    inspector = PDF::Inspector::Text.analyze(pdf_data)
    text = inspector.strings.join(" ")

    # Issuer block
    assert_includes text, invoice.organization.rtn
    assert_includes text, invoice.organization.phone
    assert_includes text, invoice.organization.email

    # Document block
    assert_includes text, invoice.cai_authorization.cai[0, 25]
    assert_includes text, invoice.correlativo
    assert_includes text, "FACTURA"

    # Customer block — RTN prominently
    assert_includes text, "RTN: #{clients(:one).rtn}"

    # Items table — ISV % column
    assert_includes text, "ISV %"
    assert_includes text, "15%"

    # Payment method
    assert_includes text, "Efectivo"

    # Totals + mandatory legend
    assert_includes text, "Total a pagar"
    assert_includes text, "La factura es beneficio de todos"

    # Total in words
    assert_includes text, "Total en letras"

    # ORIGINAL + COPIA on separate pages
    assert_match(/ORIGINAL.*CLIENTE/i, text)
    assert_match(/COPIA.*EMISOR/i, text)
  end

  test "fiscal PDF for exonerado client shows the exoneration number" do
    client = clients(:one)
    client.update!(exonerado: true, numero_exoneracion: "EXO-2026-001")
    invoice = Invoice.create!(
      organization: organizations(:default_organization),
      client: client,
      establishment: establishments(:main),
      emission_point: emission_points(:main),
      document_type: document_types(:factura),
      cai_authorization: cai_authorizations(:factura_active),
      invoice_items_attributes: [
        { product_id: products(:one).id, quantity: 1, unit_price: 50, description: "Test" }
      ]
    )

    pdf_data = InvoicePdf.new(invoice, :es).render
    text = PDF::Inspector::Text.analyze(pdf_data).strings.join(" ")
    assert_includes text, "EXO-2026-001"
  end

  test "legacy invoice PDF still renders without SAR fields" do
    pdf_data = InvoicePdf.new(invoices(:one), :en).render
    text = PDF::Inspector::Text.analyze(pdf_data).strings.join(" ")
    assert_includes text, "INVOICE"
  end
end
