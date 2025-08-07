class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Validations
  validates :email_address, presence: true, uniqueness: true
  validates :name, presence: true
  validates :language, inclusion: { in: %w[en es] }
  validates :default_tax, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  # Set defaults
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.language ||= "en"
    self.name ||= "User"
    self.default_tax ||= 0.15
  end
end
