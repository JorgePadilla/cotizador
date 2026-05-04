class CreateEstablishments < ActiveRecord::Migration[8.0]
  def change
    create_table :establishments do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :codigo, null: false, limit: 3
      t.string :nombre, null: false
      t.text :address
      t.string :phone
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :establishments, [ :organization_id, :codigo ], unique: true
  end
end
