class AddOrganizationToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :organization, null: true, foreign_key: true
  end
end
