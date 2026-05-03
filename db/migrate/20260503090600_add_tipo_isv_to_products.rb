class AddTipoIsvToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :tipo_isv, :string, null: false, default: "gravado_15"
  end
end
