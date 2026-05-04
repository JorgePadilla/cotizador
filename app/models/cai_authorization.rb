class CaiAuthorization < ApplicationRecord
  CAI_FORMAT = /\A([A-Z0-9]{6}-){7}[A-Z0-9]{1}\z/

  self.locking_column = :lock_version

  belongs_to :emission_point
  belongs_to :document_type
  has_one :establishment, through: :emission_point
  has_one :organization, through: :establishment

  validates :cai, presence: true, format: { with: CAI_FORMAT }
  validates :rango_inicial, :rango_final, presence: true,
                                          numericality: { only_integer: true, greater_than: 0 }
  validates :fecha_limite_emision, presence: true
  validate :rango_final_gte_inicial
  validate :only_one_active_per_emission_point_and_document_type, if: :active?

  scope :active, -> { where(active: true) }

  def vigente?
    active? && fecha_limite_emision.present? && fecha_limite_emision >= Date.current && correlativo_actual < rango_final
  end

  def agotado?
    correlativo_actual >= rango_final
  end

  def restantes
    rango_final - correlativo_actual
  end

  def dias_para_expirar
    return nil if fecha_limite_emision.nil?

    (fecha_limite_emision - Date.current).to_i
  end

  def format_correlativo(numero)
    "#{establishment.codigo}-#{emission_point.codigo}-#{document_type.code}-#{numero.to_s.rjust(8, '0')}"
  end

  def next_correlativo_preview
    format_correlativo(correlativo_actual + 1)
  end

  private

  def rango_final_gte_inicial
    return if rango_inicial.blank? || rango_final.blank?
    return if rango_final >= rango_inicial

    errors.add(:rango_final, :must_be_gte_rango_inicial)
  end

  def only_one_active_per_emission_point_and_document_type
    scope = self.class.where(emission_point_id: emission_point_id,
                             document_type_id: document_type_id,
                             active: true)
    scope = scope.where.not(id: id) if persisted?
    return unless scope.exists?

    errors.add(:base, :duplicate_active_cai)
  end
end
