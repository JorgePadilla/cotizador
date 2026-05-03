class CreateEmissionPoints < ActiveRecord::Migration[8.0]
  def change
    create_table :emission_points do |t|
      t.references :establishment, null: false, foreign_key: true
      t.string :codigo, null: false, limit: 3
      t.string :descripcion
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :emission_points, [:establishment_id, :codigo], unique: true
  end
end
