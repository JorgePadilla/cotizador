require "test_helper"

class CreditNoteTest < ActiveSupport::TestCase
  setup do
    @original = build_fiscal_invoice
    @original.save!
  end

  test "from_invoice clones items and inherits fiscal context" do
    note = CreditNote.from_invoice(@original)
    assert_equal @original.client_id, note.client_id
    assert_equal @original.emission_point_id, note.emission_point_id
    assert_equal DocumentType.credit_note, note.document_type
    assert_equal @original.invoice_items.size, note.invoice_items.size
  end

  test "credit note saves and gets a credit-note correlativo" do
    note = CreditNote.from_invoice(@original)
    assert note.save, note.errors.full_messages.to_sentence
    assert_equal "001-001-03-00000001", note.correlativo
    assert_equal "credit_note", note.invoice_kind
  end

  test "original_invoice_id is required" do
    note = CreditNote.new(organization: organizations(:default_organization), client: clients(:one))
    assert_not note.valid?
    assert note.errors[:original_invoice_id].present?
  end

  test "original cannot itself be a credit note" do
    note = CreditNote.from_invoice(@original)
    note.save!
    second = CreditNote.from_invoice(note)
    assert_nil second  # from_invoice rejects non-fiscal-invoice originals
  end

  private

  def build_fiscal_invoice
    Invoice.new(
      organization: organizations(:default_organization),
      client: clients(:one),
      establishment: establishments(:main),
      emission_point: emission_points(:main),
      document_type: document_types(:factura),
      cai_authorization: cai_authorizations(:factura_active),
      invoice_items_attributes: [
        { product_id: products(:one).id, quantity: 1, unit_price: 100, description: "test" }
      ]
    )
  end
end
