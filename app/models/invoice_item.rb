class InvoiceItem < ApplicationRecord
  TIPO_ISV_VALUES = %w[exento exonerado gravado_15 gravado_18].freeze

  belongs_to :invoice
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :tipo_isv_override, inclusion: { in: TIPO_ISV_VALUES }, allow_blank: true

  before_validation :calculate_total_and_isv

  def resolved_tipo_isv
    tipo_isv_override.presence || product&.tipo_isv || "gravado_15"
  end

  private

  def calculate_total_and_isv
    self.total = quantity * unit_price if quantity.present? && unit_price.present?
    self.tipo_isv_resolved = resolved_tipo_isv
    rate = Invoice::ISV_RATES[tipo_isv_resolved] || BigDecimal("0")
    self.isv_amount = ((total || 0) * rate).round(2)
  end
end
