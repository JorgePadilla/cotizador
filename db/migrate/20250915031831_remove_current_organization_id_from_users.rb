class RemoveCurrentOrganizationIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :current_organization_id, :bigint
  end
end
