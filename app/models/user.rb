class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Validations
  validates :language, inclusion: { in: %w[en es] }
  validates :default_tax, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  # Set default language
  after_initialize :set_default_language, if: :new_record?

  private

  def set_default_language
    self.language ||= "en"
  end
end
