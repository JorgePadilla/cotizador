class QuoteItem < ApplicationRecord
  belongs_to :quote
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true

  before_validation :set_details_from_product, on: :create
  before_validation :calculate_total
  after_save :update_quote_totals
  after_destroy :update_quote_totals

  def calculate_total
    self.total = quantity * unit_price if quantity.present? && unit_price.present?
  end

  private

  def set_details_from_product
    return unless product && (description.blank? || unit_price.blank?)

    self.description = product.description if description.blank?
    self.unit_price = product.price if unit_price.blank?
  end

  def update_quote_totals
    quote.calculate_totals
    quote.save
  end
end
