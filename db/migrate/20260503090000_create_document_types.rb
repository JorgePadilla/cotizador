class CreateDocumentTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :document_types do |t|
      t.string :code, null: false, limit: 2
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    add_index :document_types, :code, unique: true
  end
end
