class Client < ApplicationRecord
  belongs_to :organization
  has_many :invoices, dependent: :destroy
  has_many :quotes, dependent: :destroy

  validates :name, presence: true
  validates :rtn, presence: true, uniqueness: { scope: :organization_id }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
