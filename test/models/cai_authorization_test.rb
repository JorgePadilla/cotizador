require "test_helper"

class CaiAuthorizationTest < ActiveSupport::TestCase
  setup do
    @cai = cai_authorizations(:factura_active)
  end

  test "fixture is vigente" do
    assert @cai.vigente?
    assert_not @cai.agotado?
    assert_equal 1000, @cai.restantes
    assert_operator @cai.dias_para_expirar, :>, 360
  end

  test "vigente? false when expired" do
    @cai.update!(fecha_limite_emision: Date.current - 1)
    assert_not @cai.vigente?
  end

  test "vigente? false when range exhausted" do
    @cai.update!(correlativo_actual: @cai.rango_final)
    assert_not @cai.vigente?
    assert @cai.agotado?
  end

  test "vigente? false when inactive" do
    @cai.update!(active: false)
    assert_not @cai.vigente?
  end

  test "format_correlativo pads to 8 digits" do
    expected = "001-001-01-00000042"
    assert_equal expected, @cai.format_correlativo(42)
  end

  test "next_correlativo_preview increments correlativo_actual" do
    @cai.update!(correlativo_actual: 9)
    assert_equal "001-001-01-00000010", @cai.next_correlativo_preview
  end

  test "cai format validation rejects malformed values" do
    @cai.cai = "not-a-cai"
    assert_not @cai.valid?
    assert @cai.errors[:cai].present?
  end

  test "rango_final must be greater than or equal to rango_inicial" do
    @cai.rango_final = 0
    @cai.rango_inicial = 5
    assert_not @cai.valid?
    assert @cai.errors[:rango_final].present?
  end

  test "only one active CAI per emission_point + document_type" do
    dup = CaiAuthorization.new(
      emission_point: @cai.emission_point,
      document_type: @cai.document_type,
      cai: "ZZZZZZ-DEF456-GHI789-JKL012-MNO345-PQR678-STU901-V",
      rango_inicial: 1001,
      rango_final: 2000,
      fecha_limite_emision: 1.year.from_now.to_date,
      active: true
    )
    assert_not dup.valid?
    assert dup.errors[:base].present?
  end

  test "second CAI allowed if first is inactive" do
    @cai.update!(active: false)
    second = CaiAuthorization.new(
      emission_point: @cai.emission_point,
      document_type: @cai.document_type,
      cai: "ZZZZZZ-DEF456-GHI789-JKL012-MNO345-PQR678-STU901-V",
      rango_inicial: 1001,
      rango_final: 2000,
      fecha_limite_emision: 1.year.from_now.to_date,
      active: true
    )
    assert second.valid?
  end
end
