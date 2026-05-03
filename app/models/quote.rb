class Quote < ApplicationRecord
  belongs_to :organization
  belongs_to :client
  has_many :quote_items, dependent: :destroy

  validates :quote_number, presence: true, uniqueness: { scope: :organization_id }
  validates :subtotal, :tax, :total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[draft sent approved rejected expired] }
  validates :valid_until, presence: true


  before_validation :set_quote_number, on: :create
  before_validation :calculate_totals

  def calculate_totals
    items = persisted? ? quote_items.includes(:product).to_a : quote_items.to_a
    items = items.reject(&:marked_for_destruction?)

    if items.empty?
      self.subtotal = 0
      self.tax = 0
      self.total = 0
      return
    end

    self.subtotal = items.sum { |item| item.total || 0 }
    self.tax = items.sum do |item|
      rate = Invoice::ISV_RATES[item.product&.tipo_isv].to_f
      ((item.total || 0) * rate).round(2)
    end
    self.total = subtotal + tax
  end

  private

  def set_quote_number
    return if quote_number.present?

    last_quote = Quote.where(organization_id: organization_id).order(created_at: :desc).first
    last_number = last_quote&.quote_number&.split("-")&.last&.to_i || 0
    self.quote_number = "QT-#{Time.current.strftime('%Y%m')}-#{last_number + 1}"
  end
end
