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

ActiveRecord::Schema[8.0].define(version: 2025_09_15_042733) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "rtn"
    t.text "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["email"], name: "index_clients_on_email"
    t.index ["name"], name: "index_clients_on_name"
    t.index ["organization_id"], name: "index_clients_on_organization_id"
    t.index ["rtn"], name: "index_clients_on_rtn", unique: true
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
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoice_number"
    t.uuid "client_id"
    t.decimal "subtotal", precision: 10, scale: 2
    t.integer "tax"
    t.decimal "total", precision: 10, scale: 2
    t.string "status"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["invoice_number"], name: "index_invoices_on_invoice_number", unique: true
    t.index ["organization_id"], name: "index_invoices_on_organization_id"
    t.index ["status"], name: "index_invoices_on_status"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "phone"
    t.string "email"
    t.string "tax_id"
    t.string "currency"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "tax"
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

  add_foreign_key "clients", "organizations"
  add_foreign_key "invitations", "organizations"
  add_foreign_key "invitations", "users", column: "invited_by_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoices", "clients"
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
