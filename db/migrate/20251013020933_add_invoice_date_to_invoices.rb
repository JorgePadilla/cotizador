class AddInvoiceDateToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :invoice_date, :date
  end
end
