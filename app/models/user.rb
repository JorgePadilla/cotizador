class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :organization, optional: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Validations
  validates :email_address, presence: true, uniqueness: true
  validates :name, presence: true
  validates :language, inclusion: { in: %w[en es] }
  validates :currency, inclusion: { in: %w[USD HNL EUR] }
  validates :default_tax, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :role, inclusion: { in: [ 0, 1, 2 ] }

  # Set defaults
  after_initialize :set_defaults, if: :new_record?

  def role_string
    case role
    when 0 then "owner"
    when 1 then "admin"
    when 2 then "member"
    else role.to_s
    end
  end

  def owner?
    role == 0
  end

  def admin?
    role == 1
  end

  def member?
    role == 2
  end

  private

  def set_defaults
    self.language ||= "en"
    self.currency ||= "USD"
    self.default_tax ||= 15
    self.role ||= 2
  end
end
