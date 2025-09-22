class OrganizationUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :role, inclusion: { in: [0, 1, 2] }

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
end