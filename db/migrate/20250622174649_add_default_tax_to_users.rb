class AddDefaultTaxToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :default_tax, :decimal, precision: 5, scale: 2, default: 0.15
  end
end
