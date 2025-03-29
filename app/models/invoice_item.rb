class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :product
  
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  
  before_validation :calculate_total
  
  private
  
  def calculate_total
    self.total = quantity * unit_price if quantity.present? && unit_price.present?
  end
end
