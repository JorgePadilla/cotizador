class ExpandCaiAuthorizationCaiLimit < ActiveRecord::Migration[8.0]
  def up
    change_column :cai_authorizations, :cai, :string, limit: 50
  end

  def down
    change_column :cai_authorizations, :cai, :string, limit: 49
  end
end
