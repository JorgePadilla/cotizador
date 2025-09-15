# This file creates seed data for the application with 2 records per model
# The data can be loaded with bin/rails db:seed

# Clear existing data to avoid duplicates
puts "Cleaning database..."
[ InvoiceItem, Invoice, Product, Client, Supplier, User ].each(&:delete_all)

# Create Users
puts "Creating users..."
users = [
  {
    email_address: "admin@example.com",
    password: "password",
    default_tax: 0.15 # 15% default tax
  },
  {
    email_address: "user@example.com",
    password: "password",
    default_tax: 0.18 # 18% default tax
  }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end

# Create Clients
puts "Creating clients..."
clients = [
  {
    name: "Acme Corporation",
    rtn: "08019999123456",
    address: "123 Main St, Anytown, USA",
    phone: "555-123-4567",
    email: "contact@acme.com"
  },
  {
    name: "Globex Industries",
    rtn: "08019999654321",
    address: "456 Oak Ave, Somewhere, USA",
    phone: "555-987-6543",
    email: "info@globex.com"
  }
]

clients.each do |client_attrs|
  Client.create!(client_attrs)
end

# Create Suppliers
puts "Creating suppliers..."
suppliers = [
  {
    name: "TechSupply Co.",
    rtn: "08019999111222",
    phone: "555-111-2222",
    email: "sales@techsupply.com",
    contact_name: "John Smith"
  },
  {
    name: "Office Solutions Inc.",
    rtn: "08019999333444",
    phone: "555-333-4444",
    email: "orders@officesolutions.com",
    contact_name: "Jane Doe"
  }
]

suppliers.each do |supplier_attrs|
  Supplier.create!(supplier_attrs)
end

# Create Products
puts "Creating products..."
products = [
  {
    name: "Laptop Pro X1",
    description: "High-performance laptop with 16GB RAM and 512GB SSD",
    sku: "LP-X1-001",
    price: 1299.99,
    stock: 10,
    supplier: Supplier.find_by(name: "TechSupply Co.")
  },
  {
    name: "Ergonomic Office Chair",
    description: "Adjustable office chair with lumbar support",
    sku: "OC-ERG-002",
    price: 249.99,
    stock: 15,
    supplier: Supplier.find_by(name: "Office Solutions Inc.")
  },
  {
    name: "Wireless Mouse",
    description: "Bluetooth wireless mouse with ergonomic design",
    sku: "ACC-WM-003",
    price: 39.99,
    stock: 25,
    supplier: Supplier.find_by(name: "TechSupply Co.")
  },
  {
    name: "Premium Notebook",
    description: "Hardcover notebook with 200 pages",
    sku: "STN-NB-004",
    price: 12.99,
    stock: 50,
    supplier: Supplier.find_by(name: "Office Solutions Inc.")
  }
]

products.each do |product_attrs|
  Product.create!(product_attrs)
end

# Create Invoices
puts "Creating invoices..."
invoices = [
  {
    invoice_number: "INV-2025-001",
    client: Client.find_by(name: "Acme Corporation"),
    status: "paid",
    payment_method: "credit_card",
    subtotal: 0,  # Will be calculated from items
    tax: 0,       # Will be calculated from items
    total: 0      # Will be calculated from items
  },
  {
    invoice_number: "INV-2025-002",
    client: Client.find_by(name: "Globex Industries"),
    status: "pending",
    payment_method: "bank_transfer",
    subtotal: 0,  # Will be calculated from items
    tax: 0,       # Will be calculated from items
    total: 0      # Will be calculated from items
  }
]

invoices.each do |invoice_attrs|
  Invoice.create!(invoice_attrs)
end

# Create Invoice Items
puts "Creating invoice items..."
invoice_items = [
  {
    invoice: Invoice.find_by(invoice_number: "INV-2025-001"),
    product: Product.find_by(sku: "LP-X1-001"),
    description: "Laptop Pro X1",
    quantity: 2,
    unit_price: 1299.99,
    total: 2599.98
  },
  {
    invoice: Invoice.find_by(invoice_number: "INV-2025-001"),
    product: Product.find_by(sku: "ACC-WM-003"),
    description: "Wireless Mouse",
    quantity: 2,
    unit_price: 39.99,
    total: 79.98
  },
  {
    invoice: Invoice.find_by(invoice_number: "INV-2025-002"),
    product: Product.find_by(sku: "OC-ERG-002"),
    description: "Ergonomic Office Chair",
    quantity: 5,
    unit_price: 249.99,
    total: 1249.95
  },
  {
    invoice: Invoice.find_by(invoice_number: "INV-2025-002"),
    product: Product.find_by(sku: "STN-NB-004"),
    description: "Premium Notebook",
    quantity: 10,
    unit_price: 12.99,
    total: 129.90
  }
]

invoice_items.each do |item_attrs|
  InvoiceItem.create!(item_attrs)
end

# Update invoice totals
puts "Updating invoice totals..."
Invoice.all.each do |invoice|
  subtotal = invoice.invoice_items.sum(&:total)
  tax = (subtotal * 0.15).round  # 15% tax rate, rounded to integer
  total = subtotal + tax

  invoice.update(
    subtotal: subtotal.round(2),
    tax: tax.round(2),
    total: total.round(2)
  )
end

puts "Seed data created successfully!"
