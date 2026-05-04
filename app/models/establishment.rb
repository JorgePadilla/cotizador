class Establishment < ApplicationRecord
  belongs_to :organization
  has_many :emission_points, dependent: :restrict_with_error

  validates :codigo, presence: true, format: { with: /\A\d{3}\z/ },
                     uniqueness: { scope: :organization_id }
  validates :nombre, presence: true

  scope :active, -> { where(active: true) }
end
