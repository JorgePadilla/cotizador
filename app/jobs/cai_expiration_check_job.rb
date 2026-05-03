class CaiExpirationCheckJob < ApplicationJob
  queue_as :default

  EXPIRATION_WARNING_DAYS = 30
  RANGE_WARNING_REMAINING = 100

  def perform
    CaiAuthorization.includes(emission_point: { establishment: { organization: :users } })
                    .where(active: true)
                    .find_each do |cai|
      next unless cai.dias_para_expirar.to_i <= EXPIRATION_WARNING_DAYS || cai.restantes <= RANGE_WARNING_REMAINING

      cai.organization.users.where(role: [ 0, 1 ]).find_each do |user|
        CaiAlertMailer.warning(cai, user).deliver_later
      end
    end
  end
end
