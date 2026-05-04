require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "valid invoice" do
    client = clients(:one)
    organization = organizations(:default_organization)
    invoice = Invoice.new(
      invoice_number: "INV001",
      client: client,
      organization: organization,
      subtotal: 100.00,
      tax: 15.00,
      total: 115.00,
      status: "pending",
      payment_method: "cash"
    )
    assert invoice.valid?
  end

  test "invoice without invoice_number is invalid" do
    client = clients(:one)
    organization = organizations(:default_organization)
    invoice = Invoice.new(
      client: client,
      organization: organization,
      subtotal: 100.00,
      tax: 15.00,
      total: 115.00,
      status: "pending",
      payment_method: "cash"
    )
    assert_not invoice.valid?
  end

  test "invoice without client is invalid" do
    organization = organizations(:default_organization)
    invoice = Invoice.new(
      invoice_number: "INV001",
      organization: organization,
      subtotal: 100.00,
      tax: 15.00,
      total: 115.00,
      status: "pending",
      payment_method: "cash"
    )
    assert_not invoice.valid?
  end

  test "invoice with negative total is invalid" do
    client = clients(:one)
    organization = organizations(:default_organization)
    invoice = Invoice.new(
      invoice_number: "INV001",
      client: client,
      organization: organization,
      subtotal: 100.00,
      tax: 15.00,
      total: -10.00,
      status: "pending",
      payment_method: "cash"
    )
    assert_not invoice.valid?
  end

  test "invoice belongs to client" do
    invoice = Invoice.reflect_on_association(:client)
    assert_equal :belongs_to, invoice.macro
  end

  test "invoice has many invoice_items" do
    invoice = Invoice.reflect_on_association(:invoice_items)
    assert_equal :has_many, invoice.macro
  end

  # ── SAR fiscal-invoicing tests ──────────────────────────────────────────────

  test "legacy invoice (no CAI) is not fiscal and remains mutable" do
    invoice = invoices(:one)
    assert_not invoice.fiscal?
    assert_not invoice.immutable?
    assert invoice.update(payment_method: "credit_card")
    assert invoice.update(invoice_number: "INV-mutated")
  end

  test "fiscal invoice gets correlativo atomically and becomes immutable" do
    fiscal = build_fiscal_invoice
    assert fiscal.save, fiscal.errors.full_messages.to_sentence
    assert fiscal.fiscal?
    assert fiscal.immutable?
    assert_equal "001-001-01-00000001", fiscal.correlativo
    assert_equal 1, fiscal.correlativo_numero
    assert_equal 1, cai_authorizations(:factura_active).reload.correlativo_actual
  end

  test "fiscal invoice update is restricted to status and payment_method" do
    fiscal = build_fiscal_invoice
    fiscal.save!

    assert fiscal.update(status: "paid")
    assert fiscal.update(payment_method: "credit_card")

    assert_not fiscal.update(invoice_number: "tampered")
    assert fiscal.errors[:base].any? { |e| e.include?("immutable") || e.include?("modificarse") }
  end

  test "fiscal invoice cannot be destroyed" do
    fiscal = build_fiscal_invoice
    fiscal.save!
    assert_no_difference("Invoice.count") { fiscal.destroy }
    assert fiscal.errors[:base].present?
  end

  test "fiscal invoice rejects expired CAI" do
    cai_authorizations(:factura_active).update_columns(fecha_limite_emision: Date.current - 1)
    fiscal = build_fiscal_invoice
    assert_not fiscal.save
    assert fiscal.errors[:cai_authorization].present?
  end

  test "fiscal invoice rejects exhausted CAI" do
    cai = cai_authorizations(:factura_active)
    cai.update_columns(correlativo_actual: cai.rango_final)
    fiscal = build_fiscal_invoice
    assert_not fiscal.save
  end

  test "fiscal invoice requires 14-digit issuer RTN" do
    organizations(:default_organization).update_columns(rtn: "invalid")
    fiscal = build_fiscal_invoice
    assert_not fiscal.save
    assert fiscal.errors[:base].present?
  end

  test "ISV breakdown reflects per-line tipo_isv (gravado_15 + gravado_18 + exento)" do
    p15 = products(:one).tap  { |p| p.update!(tipo_isv: "gravado_15") }
    p18 = products(:two).tap  { |p| p.update!(tipo_isv: "gravado_18") }
    pex = create_product("EXEMPT-001", "Exento", "exento")

    fiscal = build_fiscal_invoice(items: [
      { product: p15, quantity: 2, unit_price: 100 },
      { product: p18, quantity: 1, unit_price: 200 },
      { product: pex, quantity: 5, unit_price: 50 }
    ])
    fiscal.save!

    assert_equal 200, fiscal.gravado_15.to_f
    assert_equal 200, fiscal.gravado_18.to_f
    assert_equal 250, fiscal.importe_exento.to_f
    assert_equal 30,  fiscal.isv_15.to_f   # 200 * 0.15
    assert_equal 36,  fiscal.isv_18.to_f   # 200 * 0.18
    assert_equal 66,  fiscal.tax.to_f
    assert_equal 650, fiscal.subtotal.to_f
    assert_equal 716, fiscal.total.to_f
  end

  test "tipo_isv_override on a line beats the product default" do
    p15 = products(:one).tap { |p| p.update!(tipo_isv: "gravado_15") }
    fiscal = build_fiscal_invoice(items: [
      { product: p15, quantity: 1, unit_price: 100, tipo_isv_override: "exonerado" }
    ])
    fiscal.save!
    assert_equal 100, fiscal.importe_exonerado.to_f
    assert_equal 0,   fiscal.gravado_15.to_f
  end

  test "atomic correlativo issuance under concurrent threads produces unique sequential numbers" do
    skip "PG_NO_THREAD_TEST" if ENV["SKIP_THREAD_TESTS"]

    seed_data = {
      organization_id: organizations(:default_organization).id,
      client_id: clients(:one).id,
      establishment_id: establishments(:main).id,
      emission_point_id: emission_points(:main).id,
      document_type_id: document_types(:factura).id,
      cai_authorization_id: cai_authorizations(:factura_active).id,
      product_id: products(:one).id
    }

    correlativos = Concurrent::Array.new
    threads = 5.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          inv = Invoice.new(
            client_id: seed_data[:client_id],
            organization_id: seed_data[:organization_id],
            establishment_id: seed_data[:establishment_id],
            emission_point_id: seed_data[:emission_point_id],
            document_type_id: seed_data[:document_type_id],
            cai_authorization_id: seed_data[:cai_authorization_id],
            invoice_items_attributes: [
              { product_id: seed_data[:product_id], quantity: 1, unit_price: 100, description: "X" }
            ]
          )
          inv.save!
          correlativos << inv.correlativo_numero
        end
      end
    end
    threads.each(&:join)

    assert_equal 5, correlativos.uniq.size, "Expected 5 unique correlativos, got: #{correlativos.sort.inspect}"
    assert_equal (1..5).to_a, correlativos.sort
  end

  private

  def build_fiscal_invoice(items: nil)
    items ||= [ { product: products(:one), quantity: 1, unit_price: 100 } ]
    Invoice.new(
      organization: organizations(:default_organization),
      client: clients(:one),
      establishment: establishments(:main),
      emission_point: emission_points(:main),
      document_type: document_types(:factura),
      cai_authorization: cai_authorizations(:factura_active),
      invoice_items_attributes: items.map.with_index { |i, idx|
        { product_id: i[:product].id, quantity: i[:quantity], unit_price: i[:unit_price],
          description: "line #{idx}", tipo_isv_override: i[:tipo_isv_override] }
      }
    )
  end

  def create_product(sku, name, tipo_isv)
    Product.create!(
      organization: organizations(:default_organization),
      supplier: suppliers(:one),
      name: name, sku: sku, price: 50, tipo_isv: tipo_isv
    )
  end
end
