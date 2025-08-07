# Script to create 30 sample quotes
# Run with: rails runner create_sample_quotes.rb

# Ensure we have suppliers to work with
suppliers = Supplier.all
if suppliers.empty?
  puts "No suppliers found. Creating sample suppliers first..."
  suppliers = [
    Supplier.create!(name: "Tech Supplier Inc", rtn: "SUP001", contact_name: "John Doe", phone: "555-1001", email: "john@techsupplier.com"),
    Supplier.create!(name: "Service Solutions Ltd", rtn: "SUP002", contact_name: "Jane Smith", phone: "555-1002", email: "jane@servicesolutions.com")
  ]
else
  suppliers = Supplier.all
end

# Ensure we have clients to work with
clients = Client.all
if clients.empty?
  puts "No clients found. Creating sample clients first..."
  clients = [
    Client.create!(name: "Acme Corporation", rtn: "RTN001", address: "123 Business St", phone: "555-0001", email: "contact@acme.com"),
    Client.create!(name: "Tech Solutions Ltd", rtn: "RTN002", address: "456 Innovation Ave", phone: "555-0002", email: "info@techsolutions.com"),
    Client.create!(name: "Global Enterprises", rtn: "RTN003", address: "789 Corporate Blvd", phone: "555-0003", email: "sales@global.com"),
    Client.create!(name: "Local Services Co", rtn: "RTN004", address: "321 Service Rd", phone: "555-0004", email: "hello@localservices.com"),
    Client.create!(name: "Premium Consulting", rtn: "RTN005", address: "654 Executive Plaza", phone: "555-0005", email: "contact@premium.com")
  ]
end

# Ensure we have products to work with
products = Product.all
if products.empty?
  puts "No products found. Creating sample products first..."
  products = [
    Product.create!(name: "Web Development", sku: "WEB001", description: "Professional web development services", price: 75.00, cost: 45.00, stock: 100, supplier: suppliers.sample),
    Product.create!(name: "Mobile App Development", sku: "MOB001", description: "Mobile application development", price: 85.00, cost: 50.00, stock: 50, supplier: suppliers.sample),
    Product.create!(name: "Database Design", sku: "DB001", description: "Database architecture and design", price: 90.00, cost: 55.00, stock: 75, supplier: suppliers.sample),
    Product.create!(name: "System Integration", sku: "SYS001", description: "System integration services", price: 95.00, cost: 60.00, stock: 30, supplier: suppliers.sample),
    Product.create!(name: "Technical Consulting", sku: "CON001", description: "Technical consulting and advisory", price: 125.00, cost: 75.00, stock: 25, supplier: suppliers.sample),
    Product.create!(name: "Project Management", sku: "PM001", description: "Project management services", price: 100.00, cost: 65.00, stock: 40, supplier: suppliers.sample),
    Product.create!(name: "Quality Assurance", sku: "QA001", description: "Quality assurance and testing", price: 65.00, cost: 40.00, stock: 60, supplier: suppliers.sample),
    Product.create!(name: "UI/UX Design", sku: "UX001", description: "User interface and experience design", price: 80.00, cost: 50.00, stock: 35, supplier: suppliers.sample),
    Product.create!(name: "DevOps Services", sku: "DEV001", description: "DevOps and infrastructure services", price: 110.00, cost: 70.00, stock: 20, supplier: suppliers.sample),
    Product.create!(name: "Maintenance & Support", sku: "SUP001", description: "Ongoing maintenance and support", price: 55.00, cost: 35.00, stock: 80, supplier: suppliers.sample)
  ]
else
  products = Product.all
end

# Quote statuses and their probabilities
statuses = [
  [ 'draft', 0.3 ],
  [ 'sent', 0.25 ],
  [ 'approved', 0.2 ],
  [ 'rejected', 0.15 ],
  [ 'expired', 0.1 ]
]

puts "Creating 30 sample quotes..."

30.times do |i|
  # Select random client
  client = clients.sample

  # Select random status based on weights
  rand_val = rand
  cumulative = 0
  status = statuses.find { |_, weight| cumulative += weight; rand_val <= cumulative }[0]

  # Generate valid_until based on status
  valid_until = case status
  when 'expired'
    rand(30..90).days.ago.to_date
  when 'approved', 'rejected'
    rand(1..30).days.ago.to_date
  else
    rand(15..60).days.from_now.to_date
  end

  # Create the quote (totals will be calculated automatically)
  # We'll let the model generate the quote_number automatically
  quote = Quote.new(
    client: client,
    status: status,
    valid_until: valid_until,
    created_at: rand(90.days.ago..Time.current)
  )

  # Force unique quote number by adding a timestamp suffix if needed
  base_time = Time.current
  quote.quote_number = nil # Let the model generate it
  begin
    quote.save!
  rescue ActiveRecord::RecordInvalid => e
    if e.message.include?("Quote number has already been taken")
      # Generate a unique quote number manually
      last_quote = Quote.order(created_at: :desc).first
      last_number = last_quote&.quote_number&.split("-")&.last&.to_i || 0
      quote.quote_number = "QT-#{base_time.strftime('%Y%m')}-#{last_number + i + 1000}"
      quote.save!
    else
      raise e
    end
  end

  # Add 1-5 quote items to each quote
  items_count = rand(1..5)
  items_count.times do
    product = products.sample
    quantity = rand(1..10)

    QuoteItem.create!(
      quote: quote,
      product: product,
      quantity: quantity
    )
  end

  # Recalculate totals after adding items
  quote.calculate_totals
  quote.save!

  puts "Created quote #{quote.quote_number} for #{client.name} (#{status})"
end

puts "\nSample quotes creation completed!"
puts "Total quotes in database: #{Quote.count}"
