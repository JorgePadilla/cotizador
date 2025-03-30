class AddIndexesToTables < ActiveRecord::Migration[8.0]
  def change
    # Add indexes to clients table
    add_index :clients, :name
    add_index :clients, :email
    add_index :clients, :rtn, unique: true
    
    # Add indexes to suppliers table
    add_index :suppliers, :name
    add_index :suppliers, :email
    add_index :suppliers, :rtn, unique: true
    
    # Add indexes to products table
    add_index :products, :name
    add_index :products, :sku, unique: true
    add_index :products, :supplier_id
    
    # Add indexes to invoices table
    add_index :invoices, :invoice_number, unique: true
    add_index :invoices, :client_id
    add_index :invoices, :status
    
    # Add indexes to invoice_items table
    add_index :invoice_items, :invoice_id
    add_index :invoice_items, :product_id
  end
end
