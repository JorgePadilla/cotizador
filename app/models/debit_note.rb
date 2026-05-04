class DebitNote < Invoice
  validates :original_invoice_id, presence: true
  validate :original_must_be_an_invoice
  validate :original_in_same_emission_point

  before_validation :inherit_fiscal_context_from_original, on: :create

  def self.from_invoice(original)
    return nil unless original.is_a?(Invoice) && original.fiscal? && original.invoice_kind == "invoice"

    new(
      organization_id: original.organization_id,
      client_id: original.client_id,
      establishment_id: original.establishment_id,
      emission_point_id: original.emission_point_id,
      document_type: DocumentType.debit_note,
      original_invoice: original,
      invoice_items_attributes: original.invoice_items.map { |it|
        { product_id: it.product_id, description: it.description,
          quantity: it.quantity, unit_price: it.unit_price,
          tipo_isv_override: it.tipo_isv_override }
      }
    )
  end

  private

  def inherit_fiscal_context_from_original
    return unless original_invoice

    self.organization_id   ||= original_invoice.organization_id
    self.establishment_id  ||= original_invoice.establishment_id
    self.emission_point_id ||= original_invoice.emission_point_id
    self.document_type     ||= DocumentType.debit_note
    self.cai_authorization ||= emission_point&.active_cai_for(document_type) if emission_point
  end

  def original_must_be_an_invoice
    return if original_invoice.nil?
    return if original_invoice.invoice_kind == "invoice"

    errors.add(:original_invoice, :must_be_invoice)
  end

  def original_in_same_emission_point
    return if original_invoice.nil? || emission_point_id.nil?
    return if original_invoice.emission_point_id == emission_point_id

    errors.add(:original_invoice, :different_emission_point)
  end
end
