class CreateQuoteItems < ActiveRecord::Migration[8.0]
  def change
    create_table :quote_items, id: :uuid do |t|
      t.references :quote, null: false, foreign_key: true, type: :uuid
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.text :description
      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
