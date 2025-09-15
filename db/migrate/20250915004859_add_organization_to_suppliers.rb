class AddOrganizationToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_reference :suppliers, :organization, null: true, foreign_key: true
  end
end
