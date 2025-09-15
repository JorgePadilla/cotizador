class Invoice < ApplicationRecord
  belongs_to :organization
  belongs_to :client
  has_many :invoice_items, dependent: :destroy
  has_many :products, through: :invoice_items

  accepts_nested_attributes_for :invoice_items, allow_destroy: true, reject_if: proc { |attrs| attrs["product_id"].blank? }

  validates :invoice_number, presence: true, uniqueness: { scope: :organization_id }
  validates :subtotal, :tax, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validates :status, inclusion: { in: %w[draft pending paid cancelled] }, allow_nil: true


  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.status ||= "draft"
    self.subtotal ||= 0
    self.tax ||= 0
    self.total ||= 0
  end
end
