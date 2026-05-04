class AddSarFieldsToOrganizations < ActiveRecord::Migration[8.0]
  def change
    rename_column :organizations, :tax_id, :rtn
    add_column :organizations, :nombre_comercial, :string
    add_column :organizations, :casa_matriz_address, :text
  end
end
