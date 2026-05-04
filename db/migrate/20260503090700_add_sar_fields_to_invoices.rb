class AddSarFieldsToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_reference :invoices, :cai_authorization, type: :bigint, foreign_key: true, null: true
    add_reference :invoices, :document_type, type: :bigint, foreign_key: true, null: true
    add_reference :invoices, :emission_point, type: :bigint, foreign_key: true, null: true
    add_reference :invoices, :establishment, type: :bigint, foreign_key: true, null: true

    add_column :invoices, :correlativo, :string
    add_column :invoices, :correlativo_numero, :bigint
    add_column :invoices, :invoice_kind, :string, null: false, default: "invoice"
    add_column :invoices, :original_invoice_id, :uuid
    add_foreign_key :invoices, :invoices, column: :original_invoice_id
    add_index :invoices, :original_invoice_id

    add_column :invoices, :issued_at, :datetime

    add_column :invoices, :importe_exento,    :decimal, precision: 12, scale: 2, default: 0
    add_column :invoices, :importe_exonerado, :decimal, precision: 12, scale: 2, default: 0
    add_column :invoices, :gravado_15,        :decimal, precision: 12, scale: 2, default: 0
    add_column :invoices, :gravado_18,        :decimal, precision: 12, scale: 2, default: 0
    add_column :invoices, :isv_15,            :decimal, precision: 12, scale: 2, default: 0
    add_column :invoices, :isv_18,            :decimal, precision: 12, scale: 2, default: 0
    add_column :invoices, :descuento_total,   :decimal, precision: 12, scale: 2, default: 0

    add_column :invoices, :sar_status, :string, default: "pending"
    add_column :invoices, :xml_payload, :text

    add_index :invoices, :invoice_kind

    add_index :invoices,
              [ :emission_point_id, :document_type_id, :correlativo_numero ],
              unique: true,
              where: "correlativo_numero IS NOT NULL",
              name: "index_invoices_unique_correlativo"
  end
end
