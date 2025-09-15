class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, default: 2 # Default to member
  end
end
