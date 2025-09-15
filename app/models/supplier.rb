class Supplier < ApplicationRecord
  belongs_to :organization
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :rtn, presence: true, uniqueness: { scope: :organization_id }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

end
