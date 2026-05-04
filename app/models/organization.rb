class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :suppliers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :establishments, dependent: :restrict_with_error
  has_many :emission_points, through: :establishments

  validates :name, presence: true
  validates :rtn, format: { with: /\A\d{14}\z/ }, allow_blank: true
  validates :currency, inclusion: { in: %w[USD HNL EUR] }, allow_blank: true
  validates :language, inclusion: { in: %w[en es] }, allow_blank: true

  def fiscal_enabled?
    CaiAuthorization
      .joins(emission_point: :establishment)
      .where(establishments: { organization_id: id }, active: true)
      .exists?
  end
end
