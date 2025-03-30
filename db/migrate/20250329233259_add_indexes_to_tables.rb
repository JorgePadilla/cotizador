class AddIndexesToTables < ActiveRecord::Migration[8.0]
  def change
    # Add indexes to clients table
    add_index :clients, :name unless index_exists?(:clients, :name)
    add_index :clients, :email unless index_exists?(:clients, :email)
    add_index :clients, :rtn, unique: true unless index_exists?(:clients, :rtn)
    
    # Add indexes to suppliers table
    add_index :suppliers, :name unless index_exists?(:suppliers, :name)
    add_index :suppliers, :email unless index_exists?(:suppliers, :email)
    add_index :suppliers, :rtn, unique: true unless index_exists?(:suppliers, :rtn)
    
    # Add indexes to products table
    add_index :products, :name unless index_exists?(:products, :name)
    add_index :products, :sku, unique: true unless index_exists?(:products, :sku)
    add_index :products, :supplier_id unless index_exists?(:products, :supplier_id)
    
    # Add indexes to invoices table
    add_index :invoices, :invoice_number, unique: true unless index_exists?(:invoices, :invoice_number)
    add_index :invoices, :client_id unless index_exists?(:invoices, :client_id)
    add_index :invoices, :status unless index_exists?(:invoices, :status)
    
    # Add indexes to invoice_items table
    add_index :invoice_items, :invoice_id unless index_exists?(:invoice_items, :invoice_id)
    add_index :invoice_items, :product_id unless index_exists?(:invoice_items, :product_id)
  end
end
