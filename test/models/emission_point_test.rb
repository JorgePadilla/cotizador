require "test_helper"

class EmissionPointTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert emission_points(:main).valid?
  end

  test "codigo must be 3 digits and unique per establishment" do
    est = establishments(:main)
    assert_not EmissionPoint.new(establishment: est, codigo: "1").valid?

    EmissionPoint.create!(establishment: est, codigo: "002")
    dup = EmissionPoint.new(establishment: est, codigo: "002")
    assert_not dup.valid?
  end

  test "active_cai_for returns the active authorization for a document type" do
    ep = emission_points(:main)
    cai = cai_authorizations(:factura_active)
    assert_equal cai, ep.active_cai_for(document_types(:factura))
    assert_nil ep.active_cai_for(document_types(:receipt))
  end
end
