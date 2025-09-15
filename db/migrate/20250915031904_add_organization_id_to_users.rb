class AddOrganizationIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :organization_id, :bigint
    add_index :users, :organization_id
    
    # Copy data from organization_users to users
    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE users 
          SET organization_id = organization_users.organization_id
          FROM organization_users 
          WHERE users.id = organization_users.user_id
        SQL
      end
    end
    
    # Remove organization_users table
    drop_table :organization_users
  end
end
