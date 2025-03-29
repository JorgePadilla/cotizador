class Client < ApplicationRecord
  has_many :invoices, dependent: :destroy
  
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
