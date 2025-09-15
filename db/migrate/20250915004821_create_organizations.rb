class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.string :email
      t.string :tax_id
      t.string :currency
      t.string :language

      t.timestamps
    end
  end
end
