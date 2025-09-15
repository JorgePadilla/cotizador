class Invitation < ApplicationRecord
  belongs_to :organization
  belongs_to :invited_by, class_name: "User"
  
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[owner admin member] }
  validates :token, presence: true, uniqueness: true
  
  before_validation :generate_token, on: :create
  
  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current).where(accepted_at: nil) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  
  def expired?
    expires_at <= Time.current
  end
  
  def accepted?
    accepted_at.present?
  end
  
  def pending?
    !expired? && !accepted?
  end
  
  private
  
  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
    self.expires_at ||= 7.days.from_now
  end
end