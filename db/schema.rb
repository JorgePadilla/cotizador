# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_05_03_091100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "cai_authorizations", force: :cascade do |t|
    t.bigint "emission_point_id", null: false
    t.bigint "document_type_id", null: false
    t.string "cai", limit: 50, null: false
    t.bigint "rango_inicial", null: false
    t.bigint "rango_final", null: false
    t.bigint "correlativo_actual", default: 0, null: false
    t.date "fecha_limite_emision", null: false
    t.date "fecha_resolucion"
    t.string "numero_resolucion"
    t.boolean "active", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type_id"], name: "index_cai_authorizations_on_document_type_id"
    t.index ["emission_point_id", "document_type_id", "cai"], name: "index_cai_auths_on_ep_dt_cai", unique: true
    t.index ["emission_point_id", "document_type_id"], name: "index_cai_auths_active_per_ep_dt", unique: true, where: "(active = true)"
    t.index ["emission_point_id"], name: "index_cai_authorizations_on_emission_point_id"
    t.check_constraint "correlativo_actual >= (rango_inicial - 1) AND correlativo_actual <= rango_final", name: "cai_correlativo_actual_within_range"
    t.check_constraint "rango_final >= rango_inicial", name: "cai_rango_final_gte_inicial"
  end

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "rtn"
    t.text "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.boolean "agente_retencion", default: false, null: false
    t.boolean "exonerado", default: false, null: false
    t.string "numero_exoneracion"
    t.index ["email"], name: "index_clients_on_email"
    t.index ["name"], name: "index_clients_on_name"
    t.index ["organization_id"], name: "index_clients_on_organization_id"
    t.index ["rtn"], name: "index_clients_on_rtn", unique: true
  end

  create_table "document_types", force: :cascade do |t|
    t.string "code", limit: 2, null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_document_types_on_code", unique: true
  end

  create_table "emission_points", force: :cascade do |t|
    t.bigint "establishment_id", null: false
    t.string "codigo", limit: 3, null: false
    t.string "descripcion"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id", "codigo"], name: "index_emission_points_on_establishment_id_and_codigo", unique: true
    t.index ["establishment_id"], name: "index_emission_points_on_establishment_id"
  end

  create_table "establishments", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "codigo", limit: 3, null: false
    t.string "nombre", null: false
    t.text "address"
    t.string "phone"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "codigo"], name: "index_establishments_on_organization_id_and_codigo", unique: true
    t.index ["organization_id"], name: "index_establishments_on_organization_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "invited_by_id", null: false
    t.string "email", null: false
    t.string "role", default: "member", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_invitations_on_email"
    t.index ["invited_by_id"], name: "index_invitations_on_invited_by_id"
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "invoice_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "invoice_id"
    t.uuid "product_id"
    t.text "description"
    t.integer "quantity"
    t.decimal "unit_price", precision: 10, scale: 2
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo_isv_override"
    t.string "tipo_isv_resolved"
    t.decimal "isv_amount", precision: 12, scale: 2, default: "0.0"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoice_number"
    t.uuid "client_id"
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "tax", precision: 12, scale: 2
    t.decimal "total", precision: 10, scale: 2
    t.string "status"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.date "invoice_date"
    t.bigint "cai_authorization_id"
    t.bigint "document_type_id"
    t.bigint "emission_point_id"
    t.bigint "establishment_id"
    t.string "correlativo"
    t.bigint "correlativo_numero"
    t.string "invoice_kind", default: "invoice", null: false
    t.uuid "original_invoice_id"
    t.datetime "issued_at"
    t.decimal "importe_exento", precision: 12, scale: 2, default: "0.0"
    t.decimal "importe_exonerado", precision: 12, scale: 2, default: "0.0"
    t.decimal "gravado_15", precision: 12, scale: 2, default: "0.0"
    t.decimal "gravado_18", precision: 12, scale: 2, default: "0.0"
    t.decimal "isv_15", precision: 12, scale: 2, default: "0.0"
    t.decimal "isv_18", precision: 12, scale: 2, default: "0.0"
    t.decimal "descuento_total", precision: 12, scale: 2, default: "0.0"
    t.string "sar_status", default: "pending"
    t.text "xml_payload"
    t.index ["cai_authorization_id"], name: "index_invoices_on_cai_authorization_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["document_type_id"], name: "index_invoices_on_document_type_id"
    t.index ["emission_point_id", "document_type_id", "correlativo_numero"], name: "index_invoices_unique_correlativo", unique: true, where: "(correlativo_numero IS NOT NULL)"
    t.index ["emission_point_id"], name: "index_invoices_on_emission_point_id"
    t.index ["establishment_id"], name: "index_invoices_on_establishment_id"
    t.index ["invoice_kind"], name: "index_invoices_on_invoice_kind"
    t.index ["organization_id", "invoice_number"], name: "index_invoices_on_organization_id_and_invoice_number", unique: true
    t.index ["organization_id"], name: "index_invoices_on_organization_id"
    t.index ["original_invoice_id"], name: "index_invoices_on_original_invoice_id"
    t.index ["status"], name: "index_invoices_on_status"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "phone"
    t.string "email"
    t.string "rtn"
    t.string "currency"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre_comercial"
    t.text "casa_matriz_address"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "cost", precision: 10, scale: 2
    t.integer "stock"
    t.uuid "supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.string "tipo_isv", default: "gravado_15", null: false
    t.index ["name"], name: "index_products_on_name"
    t.index ["organization_id"], name: "index_products_on_organization_id"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "quote_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "quote_id", null: false
    t.uuid "product_id", null: false
    t.text "description"
    t.integer "quantity"
    t.decimal "unit_price", precision: 10, scale: 2
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_quote_items_on_product_id"
    t.index ["quote_id"], name: "index_quote_items_on_quote_id"
  end

  create_table "quotes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "quote_number"
    t.uuid "client_id", null: false
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "tax", precision: 12, scale: 2
    t.decimal "total", precision: 10, scale: 2
    t.string "status", default: "draft"
    t.date "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["client_id"], name: "index_quotes_on_client_id"
    t.index ["organization_id"], name: "index_quotes_on_organization_id"
    t.index ["quote_number"], name: "index_quotes_on_quote_number", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "rtn"
    t.string "contact_name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.bigint "organization_id"
    t.index ["email"], name: "index_suppliers_on_email"
    t.index ["name"], name: "index_suppliers_on_name"
    t.index ["organization_id"], name: "index_suppliers_on_organization_id"
    t.index ["rtn"], name: "index_suppliers_on_rtn", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language", default: "en"
    t.string "name", default: "User"
    t.integer "default_tax"
    t.string "currency", default: "USD"
    t.bigint "organization_id"
    t.integer "role", default: 2
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "cai_authorizations", "document_types"
  add_foreign_key "cai_authorizations", "emission_points"
  add_foreign_key "clients", "organizations"
  add_foreign_key "emission_points", "establishments"
  add_foreign_key "establishments", "organizations"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "invitations", "users", column: "invited_by_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoices", "cai_authorizations"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "document_types"
  add_foreign_key "invoices", "emission_points"
  add_foreign_key "invoices", "establishments"
  add_foreign_key "invoices", "invoices", column: "original_invoice_id"
  add_foreign_key "invoices", "organizations"
  add_foreign_key "products", "organizations"
  add_foreign_key "products", "suppliers"
  add_foreign_key "quote_items", "products"
  add_foreign_key "quote_items", "quotes"
  add_foreign_key "quotes", "clients"
  add_foreign_key "quotes", "organizations"
  add_foreign_key "sessions", "users"
  add_foreign_key "suppliers", "organizations"
end
