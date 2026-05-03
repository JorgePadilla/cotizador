class AddSarFieldsToInvoiceItems < ActiveRecord::Migration[8.0]
  def change
    add_column :invoice_items, :tipo_isv_override, :string
    add_column :invoice_items, :tipo_isv_resolved, :string
    add_column :invoice_items, :isv_amount, :decimal, precision: 12, scale: 2, default: 0
  end
end
