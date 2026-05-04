require "test_helper"

class EstablishmentTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert establishments(:main).valid?
  end

  test "codigo must be 3 digits" do
    org = organizations(:default_organization)
    assert_not Establishment.new(organization: org, codigo: "1", nombre: "X").valid?
    assert_not Establishment.new(organization: org, codigo: "1234", nombre: "X").valid?
    assert_not Establishment.new(organization: org, codigo: "ABC", nombre: "X").valid?
    assert     Establishment.new(organization: org, codigo: "002", nombre: "X").valid?
  end

  test "codigo unique per organization" do
    org = organizations(:default_organization)
    Establishment.create!(organization: org, codigo: "002", nombre: "X")
    dup = Establishment.new(organization: org, codigo: "002", nombre: "Y")
    assert_not dup.valid?
    assert dup.errors[:codigo].present?
  end

  test "active scope" do
    establishments(:main).update!(active: false)
    assert_not Establishment.active.exists?(id: establishments(:main).id)
  end
end
