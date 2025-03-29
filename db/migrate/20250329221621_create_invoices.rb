class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    
    create_table :invoices, id: :uuid do |t|
      t.string :invoice_number
      t.references :client, type: :uuid, foreign_key: true
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :tax, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :status
      t.string :payment_method

      t.timestamps
    end
  end
end
