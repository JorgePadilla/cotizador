class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :suppliers, id: :uuid do |t|
      t.string :name
      t.string :rtn
      t.string :contact_name
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
