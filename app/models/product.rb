class Product < ApplicationRecord
  belongs_to :organization
  belongs_to :supplier
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :quote_items, dependent: :destroy
  has_many :quotes, through: :quote_items

  validates :name, presence: true
  validates :sku, presence: true, uniqueness: { scope: :organization_id }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
