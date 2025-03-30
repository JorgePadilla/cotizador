class CreateInvoiceItems < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :invoice_items, id: :uuid do |t|
      t.references :invoice, type: :uuid, foreign_key: true
      t.references :product, type: :uuid, foreign_key: true
      t.text :description
      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
