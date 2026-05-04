class RemoveGlobalUniqueIndexOnInvoiceNumber < ActiveRecord::Migration[8.0]
  def change
    remove_index :invoices, :invoice_number
    add_index :invoices, [ :organization_id, :invoice_number ], unique: true
  end
end
