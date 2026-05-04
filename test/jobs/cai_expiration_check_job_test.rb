require "test_helper"

class CaiExpirationCheckJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper
  test "alerts admin/owner users when CAI is within 30 days of expiration" do
    cai_authorizations(:factura_active).update!(fecha_limite_emision: Date.current + 25.days)

    assert_emails 2 do
      perform_enqueued_jobs { CaiExpirationCheckJob.perform_now }
    end
  end

  test "alerts when remaining range falls below 100" do
    cai_authorizations(:factura_active).update!(correlativo_actual: 950)

    assert_emails 2 do
      perform_enqueued_jobs { CaiExpirationCheckJob.perform_now }
    end
  end

  test "does not alert when CAI is healthy" do
    cai_authorizations(:factura_active).update!(
      fecha_limite_emision: 1.year.from_now.to_date,
      correlativo_actual: 0
    )
    # Other CAIs in fixtures are also healthy by default
    assert_no_emails do
      perform_enqueued_jobs { CaiExpirationCheckJob.perform_now }
    end
  end
end
