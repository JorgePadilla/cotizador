class AddAddressToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_column :suppliers, :address, :string
  end
end
