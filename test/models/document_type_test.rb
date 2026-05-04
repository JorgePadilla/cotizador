require "test_helper"

class DocumentTypeTest < ActiveSupport::TestCase
  test "code constants resolve to fixtures" do
    assert_equal "01", DocumentType::INVOICE
    assert_equal "Factura", DocumentType.invoice.name
    assert_equal "Nota de Débito", DocumentType.debit_note.name
    assert_equal "Nota de Crédito", DocumentType.credit_note.name
    assert_equal "Recibo", DocumentType.receipt.name
  end

  test "code is required and unique" do
    dt = DocumentType.new(name: "Otro")
    assert_not dt.valid?
    assert dt.errors[:code].present?

    dup = DocumentType.new(code: "01", name: "Otra Factura")
    assert_not dup.valid?
    assert dup.errors[:code].present?
  end

  test "code length is exactly 2 characters" do
    dt = DocumentType.new(code: "001", name: "X")
    assert_not dt.valid?
    assert dt.errors[:code].present?
  end
end
