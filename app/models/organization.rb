class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :suppliers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :quotes, dependent: :destroy

  validates :name, presence: true
  validates :currency, inclusion: { in: %w[USD HNL EUR] }, allow_blank: true
  validates :language, inclusion: { in: %w[en es] }, allow_blank: true
end
