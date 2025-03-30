class Supplier < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true
  validates :rtn, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
