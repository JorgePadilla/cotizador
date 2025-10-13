# This file creates seed data with 20 records per model for testing search functionality
# The data can be loaded with bin/rails db:seed:replant

# Clear existing data to avoid duplicates
puts "Cleaning database..."
[ InvoiceItem, Invoice, Quote, Product, Client, Supplier, User, Organization ].each(&:delete_all)

# Create Organizations
puts "Creating organizations..."
organization = Organization.create!(
  name: "Mi Empresa",
  currency: "HNL",
  address: "123 Calle Principal, Tegucigalpa, Honduras",
  phone: "+504 2234-5678",
  email: "info@miempresa.com",
  rtn: "08019999000001"
)

# Create Users
puts "Creating users..."
users = [
  {
    email_address: "admin@miempresa.com",
    password: "password",
    default_tax: 0.15,
    organization: organization
  },
  {
    email_address: "user@miempresa.com",
    password: "password",
    default_tax: 0.18,
    organization: organization
  }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end

# Set current organization for seed data
Current.organization = organization

# Create Clients (20 records)
puts "Creating 20 clients..."
clients = [
  { name: "Acme Corporation", rtn: "08019999123456", address: "123 Main St, Anytown, USA", phone: "555-123-4567", email: "contact@acme.com" },
  { name: "Globex Industries", rtn: "08019999654321", address: "456 Oak Ave, Somewhere, USA", phone: "555-987-6543", email: "info@globex.com" },
  { name: "Initech Solutions", rtn: "08019999112233", address: "789 Tech Blvd, Silicon Valley, CA", phone: "555-111-2222", email: "sales@initech.com" },
  { name: "Wayne Enterprises", rtn: "08019999445566", address: "1007 Mountain Drive, Gotham City", phone: "555-444-5555", email: "bruce@wayne.com" },
  { name: "Stark Industries", rtn: "08019999778899", address: "10880 Malibu Point, Malibu, CA", phone: "555-777-8888", email: "tony@stark.com" },
  { name: "Oscorp Corporation", rtn: "08019999001122", address: "1 Oscorp Tower, New York, NY", phone: "555-000-1111", email: "norman@oscorp.com" },
  { name: "Cyberdyne Systems", rtn: "08019999223344", address: "1234 Future Lane, Los Angeles, CA", phone: "555-222-3333", email: "info@cyberdyne.com" },
  { name: "Umbrella Corp", rtn: "08019999556677", address: "666 Raccoon City, Unknown", phone: "555-555-6666", email: "admin@umbrella.com" },
  { name: "Weyland-Yutani", rtn: "08019999889900", address: "1 Corporate Plaza, Tokyo, Japan", phone: "555-888-9999", email: "corporate@weyland.com" },
  { name: "Tyrell Corp", rtn: "08019999101010", address: "Off-world Colony, Mars", phone: "555-101-0101", email: "eldon@tyrell.com" },
  { name: "Blue Sun Corp", rtn: "08019999202020", address: "Persephone, Border Planets", phone: "555-202-0202", email: "contact@bluesun.com" },
  { name: "Massive Dynamic", rtn: "08019999303030", address: "1 Massive Dynamic Plaza, Boston, MA", phone: "555-303-0303", email: "info@massivedynamic.com" },
  { name: "Dunder Mifflin", rtn: "08019999404040", address: "1725 Slough Avenue, Scranton, PA", phone: "555-404-0404", email: "michael@dundermifflin.com" },
  { name: "Pied Piper", rtn: "08019999505050", address: "548 Market St, San Francisco, CA", phone: "555-505-0505", email: "richard@piedpiper.com" },
  { name: "Hooli", rtn: "08019999606060", address: "1 Hooli Way, Cupertino, CA", phone: "555-606-0606", email: "gavin@hooli.com" },
  { name: "Aperture Science", rtn: "08019999707070", address: "Cave Johnson Blvd, Cleveland, OH", phone: "555-707-0707", email: "cave@aperture.com" },
  { name: "Black Mesa", rtn: "08019999808080", address: "Black Mesa Research Facility, NM", phone: "555-808-0808", email: "research@blackmesa.com" },
  { name: "Vault-Tec", rtn: "08019999909090", address: "Vault 101, Washington DC", phone: "555-909-0909", email: "vault@vaulttec.com" },
  { name: "Axiom Corp", rtn: "08019999111111", address: "Axiom Spaceship, Earth Orbit", phone: "555-111-1111", email: "auto@axiom.com" },
  { name: "CyberLife", rtn: "08019999222222", address: "CyberLife Tower, Detroit, MI", phone: "555-222-2222", email: "info@cyberlife.com" }
]

clients.each do |client_attrs|
  Client.create!(client_attrs.merge(organization: organization))
end

# Create Suppliers (20 records)
puts "Creating 20 suppliers..."
suppliers = [
  { name: "TechSupply Co.", rtn: "08019999111222", phone: "555-111-2222", email: "sales@techsupply.com", contact_name: "John Smith" },
  { name: "Office Solutions Inc.", rtn: "08019999333444", phone: "555-333-4444", email: "orders@officesolutions.com", contact_name: "Jane Doe" },
  { name: "Global Electronics", rtn: "08019999555666", phone: "555-555-6666", email: "info@globalelectronics.com", contact_name: "Mike Johnson" },
  { name: "Premium Components", rtn: "08019999777888", phone: "555-777-8888", email: "sales@premiumcomponents.com", contact_name: "Sarah Wilson" },
  { name: "Innovative Tech", rtn: "08019999999000", phone: "555-999-0000", email: "contact@innovativetech.com", contact_name: "David Brown" },
  { name: "Digital Warehouse", rtn: "08019999123400", phone: "555-123-4000", email: "orders@digitalwarehouse.com", contact_name: "Lisa Davis" },
  { name: "Computer Parts Ltd", rtn: "08019999234500", phone: "555-234-5000", email: "info@computerparts.com", contact_name: "Robert Miller" },
  { name: "Hardware Experts", rtn: "08019999345600", phone: "555-345-6000", email: "sales@hardwareexperts.com", contact_name: "Jennifer Taylor" },
  { name: "Network Solutions", rtn: "08019999456700", phone: "555-456-7000", email: "support@networksolutions.com", contact_name: "Kevin Anderson" },
  { name: "Software Plus", rtn: "08019999567800", phone: "555-567-8000", email: "info@softwareplus.com", contact_name: "Amanda Thomas" },
  { name: "Mobile Devices Inc", rtn: "08019999678900", phone: "555-678-9000", email: "sales@mobiledevices.com", contact_name: "Brian White" },
  { name: "Accessory World", rtn: "08019999789000", phone: "555-789-0000", email: "orders@accessoryworld.com", contact_name: "Michelle Harris" },
  { name: "Gaming Gear Co", rtn: "08019999890100", phone: "555-890-1000", email: "info@gaminggear.com", contact_name: "Jason Martin" },
  { name: "Audio Visual Pro", rtn: "08019999901200", phone: "555-901-2000", email: "sales@avpro.com", contact_name: "Nicole Garcia" },
  { name: "Security Systems", rtn: "08019999012300", phone: "555-012-3000", email: "support@securitysystems.com", contact_name: "Daniel Martinez" },
  { name: "Data Storage Co", rtn: "08019999123411", phone: "555-123-4111", email: "info@datastorage.com", contact_name: "Jessica Lee" },
  { name: "Printing Solutions", rtn: "08019999234522", phone: "555-234-5222", email: "orders@printingsolutions.com", contact_name: "Christopher Walker" },
  { name: "Cloud Services Inc", rtn: "08019999345633", phone: "555-345-6333", email: "sales@cloudservices.com", contact_name: "Stephanie Hall" },
  { name: "IT Consulting", rtn: "08019999456744", phone: "555-456-7444", email: "contact@itconsulting.com", contact_name: "Matthew Young" },
  { name: "Tech Support Pro", rtn: "08019999567855", phone: "555-567-8555", email: "support@techsupportpro.com", contact_name: "Lauren King" }
]

suppliers.each do |supplier_attrs|
  Supplier.create!(supplier_attrs.merge(organization: organization))
end

# Create Products (20 records)
puts "Creating 20 products..."
products = [
  { name: "Laptop Pro X1", description: "High-performance laptop with 16GB RAM and 512GB SSD", sku: "LP-X1-001", price: 1299.99, cost: 899.99, stock: 10, supplier: Supplier.find_by(name: "TechSupply Co.") },
  { name: "Ergonomic Office Chair", description: "Adjustable office chair with lumbar support", sku: "OC-ERG-002", price: 249.99, cost: 149.99, stock: 15, supplier: Supplier.find_by(name: "Office Solutions Inc.") },
  { name: "Wireless Mouse", description: "Bluetooth wireless mouse with ergonomic design", sku: "ACC-WM-003", price: 39.99, cost: 19.99, stock: 25, supplier: Supplier.find_by(name: "TechSupply Co.") },
  { name: "Premium Notebook", description: "Hardcover notebook with 200 pages", sku: "STN-NB-004", price: 12.99, cost: 4.99, stock: 50, supplier: Supplier.find_by(name: "Office Solutions Inc.") },
  { name: "4K Monitor", description: "27-inch 4K UHD monitor with IPS panel", sku: "MON-4K-005", price: 399.99, cost: 249.99, stock: 8, supplier: Supplier.find_by(name: "Global Electronics") },
  { name: "Mechanical Keyboard", description: "RGB mechanical keyboard with Cherry MX switches", sku: "KB-MEC-006", price: 89.99, cost: 49.99, stock: 20, supplier: Supplier.find_by(name: "Premium Components") },
  { name: "Webcam HD", description: "1080p HD webcam with built-in microphone", sku: "CAM-HD-007", price: 59.99, cost: 29.99, stock: 30, supplier: Supplier.find_by(name: "Innovative Tech") },
  { name: "USB-C Hub", description: "7-in-1 USB-C hub with HDMI and Ethernet", sku: "ACC-HUB-008", price: 34.99, cost: 14.99, stock: 40, supplier: Supplier.find_by(name: "Digital Warehouse") },
  { name: "External SSD", description: "1TB external SSD with USB 3.2", sku: "SSD-EXT-009", price: 129.99, cost: 79.99, stock: 12, supplier: Supplier.find_by(name: "Computer Parts Ltd") },
  { name: "Gaming Headset", description: "Surround sound gaming headset with microphone", sku: "ACC-GHS-010", price: 79.99, cost: 39.99, stock: 18, supplier: Supplier.find_by(name: "Hardware Experts") },
  { name: "WiFi Router", description: "Dual-band WiFi 6 router with mesh support", sku: "NET-RTR-011", price: 149.99, cost: 89.99, stock: 6, supplier: Supplier.find_by(name: "Network Solutions") },
  { name: "Office Software", description: "Professional office suite license", sku: "SW-OFF-012", price: 199.99, cost: 99.99, stock: 100, supplier: Supplier.find_by(name: "Software Plus") },
  { name: "Tablet Pro", description: "10-inch tablet with stylus support", sku: "TAB-PRO-013", price: 449.99, cost: 299.99, stock: 7, supplier: Supplier.find_by(name: "Mobile Devices Inc") },
  { name: "Laptop Sleeve", description: "Protective laptop sleeve with padding", sku: "ACC-SLV-014", price: 24.99, cost: 9.99, stock: 35, supplier: Supplier.find_by(name: "Accessory World") },
  { name: "Gaming Mouse", description: "High-DPI gaming mouse with RGB lighting", sku: "ACC-GMS-015", price: 49.99, cost: 24.99, stock: 22, supplier: Supplier.find_by(name: "Gaming Gear Co") },
  { name: "Conference Speaker", description: "Bluetooth conference speaker with microphone", sku: "AV-SPK-016", price: 129.99, cost: 69.99, stock: 9, supplier: Supplier.find_by(name: "Audio Visual Pro") },
  { name: "Security Camera", description: "Wireless security camera with night vision", sku: "SEC-CAM-017", price: 89.99, cost: 44.99, stock: 14, supplier: Supplier.find_by(name: "Security Systems") },
  { name: "NAS Storage", description: "4-bay NAS storage system", sku: "NAS-4B-018", price: 499.99, cost: 349.99, stock: 3, supplier: Supplier.find_by(name: "Data Storage Co") },
  { name: "Laser Printer", description: "Color laser printer with WiFi", sku: "PRN-LAS-019", price: 299.99, cost: 199.99, stock: 5, supplier: Supplier.find_by(name: "Printing Solutions") },
  { name: "Cloud Storage", description: "1TB cloud storage subscription", sku: "CLD-1TB-020", price: 9.99, cost: 2.99, stock: 999, supplier: Supplier.find_by(name: "Cloud Services Inc") }
]

products.each do |product_attrs|
  Product.create!(product_attrs.merge(organization: organization))
end

# Create Invoices (20 records)
puts "Creating 20 invoices..."
invoices = []
20.times do |i|
  invoice_number = "INV-2025-#{(i + 1).to_s.rjust(3, '0')}"
  client = Client.all.sample
  status = ["draft", "pending", "paid", "cancelled"].sample
  payment_method = ["cash", "credit_card", "bank_transfer", "check"].sample

  invoices << {
    invoice_number: invoice_number,
    client: client,
    status: status,
    payment_method: payment_method,
    subtotal: 0,
    tax: 0,
    total: 0,
    organization: organization
  }
end

invoices.each do |invoice_attrs|
  Invoice.create!(invoice_attrs)
end

# Create Invoice Items
puts "Creating invoice items..."
Invoice.all.each do |invoice|
  # Add 1-4 random products to each invoice
  num_items = rand(1..4)
  products_sample = Product.all.sample(num_items)

  products_sample.each do |product|
    quantity = rand(1..5)
    unit_price = product.price
    total = quantity * unit_price

    InvoiceItem.create!(
      invoice: invoice,
      product: product,
      description: product.name,
      quantity: quantity,
      unit_price: unit_price,
      total: total,
      organization: organization
    )
  end
end

# Update invoice totals
puts "Updating invoice totals..."
Invoice.all.each do |invoice|
  subtotal = invoice.invoice_items.sum(&:total)
  tax = (subtotal * 0.15).round(2)  # 15% tax rate
  total = subtotal + tax

  invoice.update(
    subtotal: subtotal.round(2),
    tax: tax.round(2),
    total: total.round(2)
  )
end

# Create Quotes (20 records)
puts "Creating 20 quotes..."
quotes = []
20.times do |i|
  quote_number = "QT-2025-#{(i + 1).to_s.rjust(3, '0')}"
  client = Client.all.sample
  status = ["draft", "sent", "approved", "rejected", "expired"].sample
  valid_until = rand(7..30).days.from_now.to_date

  quotes << {
    quote_number: quote_number,
    client: client,
    status: status,
    valid_until: valid_until,
    total: rand(100.0..5000.0).round(2),
    organization: organization
  }
end

quotes.each do |quote_attrs|
  Quote.create!(quote_attrs)
end

puts "Seed data with 20 records per model created successfully!"
puts "Total records created:"
puts "- Clients: #{Client.count}"
puts "- Suppliers: #{Supplier.count}"
puts "- Products: #{Product.count}"
puts "- Invoices: #{Invoice.count}"
puts "- Quotes: #{Quote.count}"
puts "- Invoice Items: #{InvoiceItem.count}"