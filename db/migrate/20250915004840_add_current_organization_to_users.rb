class AddCurrentOrganizationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :current_organization, null: true, foreign_key: { to_table: :organizations }
  end
end
