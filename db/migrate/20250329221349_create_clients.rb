class CreateClients < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :clients, id: :uuid do |t|
      t.string :name
      t.string :rtn
      t.text :address
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
