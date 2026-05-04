class NormalizeInvoiceMoneyColumns < ActiveRecord::Migration[8.0]
  def up
    change_column :invoices, :tax, :decimal, precision: 12, scale: 2
    change_column :quotes,   :tax, :decimal, precision: 12, scale: 2
  end

  def down
    change_column :invoices, :tax, :integer
    change_column :quotes,   :tax, :integer
  end
end
