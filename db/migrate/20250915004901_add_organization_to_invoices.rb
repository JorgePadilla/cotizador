class AddOrganizationToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_reference :invoices, :organization, null: true, foreign_key: true
  end
end
