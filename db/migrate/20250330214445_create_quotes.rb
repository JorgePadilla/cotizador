class CreateQuotes < ActiveRecord::Migration[8.0]
  def change
    create_table :quotes, id: :uuid do |t|
      t.string :quote_number
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.decimal :subtotal, precision: 10, scale: 2
      t.decimal :tax, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.string :status, default: 'draft'
      t.date :valid_until

      t.timestamps
    end
    add_index :quotes, :quote_number, unique: true
  end
end
