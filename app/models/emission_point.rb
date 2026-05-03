class EmissionPoint < ApplicationRecord
  belongs_to :establishment
  has_one :organization, through: :establishment
  has_many :cai_authorizations, dependent: :restrict_with_error

  validates :codigo, presence: true, format: { with: /\A\d{3}\z/ },
                     uniqueness: { scope: :establishment_id }

  scope :active, -> { where(active: true) }

  def active_cai_for(document_type)
    cai_authorizations.where(document_type: document_type, active: true).first
  end
end
