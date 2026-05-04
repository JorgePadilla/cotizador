class DocumentType < ApplicationRecord
  INVOICE     = "01".freeze
  DEBIT_NOTE  = "02".freeze
  CREDIT_NOTE = "03".freeze
  RECEIPT     = "04".freeze

  has_many :cai_authorizations, dependent: :restrict_with_error

  validates :code, presence: true, uniqueness: true, length: { is: 2 }
  validates :name, presence: true

  def self.invoice     = find_by(code: INVOICE)
  def self.debit_note  = find_by(code: DEBIT_NOTE)
  def self.credit_note = find_by(code: CREDIT_NOTE)
  def self.receipt     = find_by(code: RECEIPT)
end
