class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :products, id: :uuid do |t|
      t.string :name
      t.string :sku
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.decimal :cost, precision: 10, scale: 2
      t.integer :stock
      t.references :supplier, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
