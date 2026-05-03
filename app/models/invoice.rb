class Invoice < ApplicationRecord
  class SarError < StandardError; end
  class ImmutableError < StandardError; end

  ISV_RATES = { "gravado_15" => BigDecimal("0.15"), "gravado_18" => BigDecimal("0.18") }.freeze
  CONSUMER_FINAL_THRESHOLD = BigDecimal("10000")

  self.inheritance_column = :invoice_kind

  STI_NAMES = { "Invoice" => "invoice", "CreditNote" => "credit_note", "DebitNote" => "debit_note" }.freeze

  def self.find_sti_class(type_name)
    case type_name
    when "invoice"     then Invoice
    when "credit_note" then CreditNote
    when "debit_note"  then DebitNote
    else super
    end
  end

  def self.sti_name
    STI_NAMES[name] || super
  end

  belongs_to :organization
  belongs_to :client
  belongs_to :cai_authorization, optional: true
  belongs_to :document_type, optional: true
  belongs_to :emission_point, optional: true
  belongs_to :establishment, optional: true
  belongs_to :original_invoice, class_name: "Invoice", optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :products, through: :invoice_items
  has_many :credit_notes, foreign_key: :original_invoice_id, class_name: "CreditNote", dependent: :restrict_with_error
  has_many :debit_notes, foreign_key: :original_invoice_id, class_name: "DebitNote", dependent: :restrict_with_error

  accepts_nested_attributes_for :invoice_items, allow_destroy: true, reject_if: proc { |attrs| attrs["product_id"].blank? }

  validates :invoice_number, presence: true, unless: :pending_correlativo?
  validates :invoice_number, uniqueness: { scope: :organization_id }, if: -> { invoice_number.present? }
  validates :subtotal, :tax, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :status, inclusion: { in: %w[draft pending paid cancelled] }, allow_nil: true

  validate :cai_must_be_vigente, if: :fiscal?
  validate :correlativo_within_range, if: -> { fiscal? && correlativo_numero.present? }
  validate :issuer_rtn_required, if: :fiscal?
  validate :customer_rtn_required_above_threshold, if: :fiscal?

  scope :fiscal, -> { where.not(cai_authorization_id: nil) }
  scope :legacy, -> { where(cai_authorization_id: nil) }

  before_validation :set_defaults, on: :create
  before_validation :resolve_fiscal_context, on: :create
  before_save :recompute_isv_breakdown, if: :fiscal?
  before_create :assign_correlativo!, if: :fiscal?
  before_update :prevent_update_if_immutable
  before_destroy :prevent_destroy_if_immutable

  def fiscal?
    cai_authorization_id.present?
  end

  def legacy?
    !fiscal?
  end

  def immutable?
    issued_at.present?
  end

  def pending_correlativo?
    fiscal? && new_record? && invoice_number.blank?
  end

  private

  def set_defaults
    self.status ||= "draft"
    self.subtotal ||= 0
    self.tax ||= 0
    self.total ||= 0
    self.invoice_date ||= Date.current
  end

  def resolve_fiscal_context
    return if cai_authorization_id.present?
    return if establishment_id.blank? || document_type_id.blank?

    establishment = Establishment.find_by(id: establishment_id)
    return if establishment.nil?

    self.emission_point_id ||= establishment.emission_points.active.pick(:id)
    return if emission_point_id.blank?

    cai = EmissionPoint.find(emission_point_id).active_cai_for(DocumentType.find(document_type_id))
    self.cai_authorization = cai if cai&.vigente?
  end

  def assign_correlativo!
    cai = cai_authorization
    cai.with_lock do
      cai.reload
      raise SarError, "CAI agotado para emission_point=#{cai.emission_point_id}" if cai.correlativo_actual >= cai.rango_final

      next_numero = cai.correlativo_actual + 1
      self.correlativo_numero = next_numero
      self.correlativo = cai.format_correlativo(next_numero)
      self.invoice_number = correlativo
      self.issued_at = Time.current
      cai.update!(correlativo_actual: next_numero)
    end
  end

  def recompute_isv_breakdown
    return if invoice_items.reject(&:marked_for_destruction?).empty?

    totals = { "exento" => BigDecimal("0"), "exonerado" => BigDecimal("0"),
               "gravado_15" => BigDecimal("0"), "gravado_18" => BigDecimal("0") }

    invoice_items.reject(&:marked_for_destruction?).each do |item|
      tipo = item.resolved_tipo_isv
      totals[tipo] = (totals[tipo] || BigDecimal("0")) + (item.total || BigDecimal("0"))
    end

    self.importe_exento    = totals["exento"]
    self.importe_exonerado = totals["exonerado"]
    self.gravado_15        = totals["gravado_15"]
    self.gravado_18        = totals["gravado_18"]
    self.isv_15            = (gravado_15 * ISV_RATES["gravado_15"]).round(2)
    self.isv_18            = (gravado_18 * ISV_RATES["gravado_18"]).round(2)

    items_subtotal = totals.values.sum
    self.subtotal  = items_subtotal - (descuento_total || 0)
    self.tax       = isv_15 + isv_18
    self.total     = subtotal + tax
  end

  def cai_must_be_vigente
    return if cai_authorization.blank?
    return if cai_authorization.vigente?

    errors.add(:cai_authorization, :not_vigente)
  end

  def correlativo_within_range
    return if cai_authorization.blank?
    return if correlativo_numero.between?(cai_authorization.rango_inicial, cai_authorization.rango_final)

    errors.add(:correlativo_numero, :out_of_range)
  end

  def issuer_rtn_required
    return if organization&.rtn.to_s.match?(/\A\d{14}\z/)

    errors.add(:base, :issuer_rtn_invalid)
  end

  def customer_rtn_required_above_threshold
    return if (total || 0) < CONSUMER_FINAL_THRESHOLD
    return if client&.rtn.to_s.match?(/\A\d{14}\z/)

    errors.add(:client, :rtn_required_above_threshold)
  end

  def prevent_update_if_immutable
    return unless immutable?

    mutable_fields = %w[status payment_method updated_at]
    forbidden = changed - mutable_fields
    return if forbidden.empty?

    errors.add(:base, :immutable)
    throw :abort
  end

  def prevent_destroy_if_immutable
    return unless immutable?

    errors.add(:base, :immutable)
    throw :abort
  end
end
