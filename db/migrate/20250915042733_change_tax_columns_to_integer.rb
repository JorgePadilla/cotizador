class ChangeTaxColumnsToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :invoices, :tax, :integer
    change_column :quotes, :tax, :integer
    change_column :users, :default_tax, :integer
  end
end
