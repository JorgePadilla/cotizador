class AddCurrencyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :currency, :string, default: "USD"
  end
end
