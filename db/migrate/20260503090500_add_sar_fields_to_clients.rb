class AddSarFieldsToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :agente_retencion, :boolean, null: false, default: false
    add_column :clients, :exonerado, :boolean, null: false, default: false
    add_column :clients, :numero_exoneracion, :string
  end
end
