# Script to generate 30 sample products for testing scalability and search
puts "=== Generating 30 Sample Products ==="

# Get the current organization
org = Organization.first
puts "Target organization: #{org.name}"

# Get available suppliers
suppliers = Supplier.all
puts "Available suppliers: #{suppliers.count}"

# Sample product categories and data
product_categories = {
  "Computers & Laptops" => [
    { name: "Gaming Laptop RTX 4060", sku: "GL-RTX4060", price: 1299.99, cost: 899.99, stock: 12 },
    { name: "Business Ultrabook", sku: "BU-ULTRA", price: 899.99, cost: 650.00, stock: 8 },
    { name: "Student Chromebook", sku: "SC-CHROME", price: 299.99, cost: 220.00, stock: 25 },
    { name: "Workstation Desktop", sku: "WD-PRO", price: 1899.99, cost: 1400.00, stock: 5 },
    { name: "All-in-One PC", sku: "AIO-27", price: 799.99, cost: 580.00, stock: 15 }
  ],
  "Office Equipment" => [
    { name: "Standing Desk Pro", sku: "SD-PRO", price: 399.99, cost: 280.00, stock: 20 },
    { name: "Executive Office Chair", sku: "EC-EXEC", price: 299.99, cost: 190.00, stock: 18 },
    { name: "Filing Cabinet 4-Drawer", sku: "FC-4DR", price: 149.99, cost: 95.00, stock: 12 },
    { name: "Conference Table Large", sku: "CT-LRG", price: 599.99, cost: 420.00, stock: 6 },
    { name: "Bookshelf Storage Unit", sku: "BS-STORAGE", price: 89.99, cost: 55.00, stock: 30 }
  ],
  "Electronics & Accessories" => [
    { name: "Wireless Keyboard Mechanical", sku: "WK-MECH", price: 89.99, cost: 45.00, stock: 35 },
    { name: "Bluetooth Speaker Premium", sku: "BS-PREMIUM", price: 129.99, cost: 75.00, stock: 22 },
    { name: "USB-C Hub 7-in-1", sku: "USB-HUB7", price: 39.99, cost: 18.00, stock: 50 },
    { name: "Webcam 4K Pro", sku: "WC-4K", price: 79.99, cost: 42.00, stock: 28 },
    { name: "Noise Cancelling Headphones", sku: "NC-HEADPH", price: 199.99, cost: 120.00, stock: 16 }
  ],
  "Software & Services" => [
    { name: "Office Suite License", sku: "SW-OFFICE", price: 149.99, cost: 80.00, stock: 100 },
    { name: "Antivirus Protection 1YR", sku: "SW-AV1YR", price: 49.99, cost: 25.00, stock: 200 },
    { name: "Cloud Storage 1TB", sku: "CLOUD-1TB", price: 99.99, cost: 40.00, stock: 0 },
    { name: "VPN Service Annual", sku: "VPN-ANNUAL", price: 79.99, cost: 35.00, stock: 0 },
    { name: "Project Management Tool", sku: "PM-TOOL", price: 29.99, cost: 15.00, stock: 150 }
  ],
  "Networking & Connectivity" => [
    { name: "WiFi Router AX6000", sku: "RT-AX6000", price: 199.99, cost: 130.00, stock: 14 },
    { name: "Network Switch 24-Port", sku: "SW-24P", price: 299.99, cost: 210.00, stock: 8 },
    { name: "Ethernet Cable Cat6 10ft", sku: "CABLE-CAT6", price: 8.99, cost: 3.50, stock: 100 },
    { name: "Mesh WiFi System 3-Pack", sku: "MESH-3PK", price: 349.99, cost: 240.00, stock: 10 },
    { name: "Network Security Appliance", sku: "NSA-PRO", price: 899.99, cost: 650.00, stock: 4 }
  ],
  "Printers & Scanners" => [
    { name: "Laser Printer Color", sku: "PRN-LASER", price: 399.99, cost: 280.00, stock: 9 },
    { name: "Document Scanner ADF", sku: "SCN-ADF", price: 249.99, cost: 160.00, stock: 11 },
    { name: "Ink Cartridge Black", sku: "INK-BLACK", price: 29.99, cost: 12.00, stock: 45 },
    { name: "Photo Printer Pro", sku: "PRN-PHOTO", price: 199.99, cost: 130.00, stock: 7 },
    { name: "Label Maker Thermal", sku: "LABEL-THERM", price: 89.99, cost: 50.00, stock: 20 }
  ]
}

# Generate products
products_created = 0
product_categories.each do |category, products|
  puts "\nCreating products for: #{category}"

  products.each do |product_data|
    # Select a random supplier
    supplier = suppliers.sample

    product = Product.new(
      name: product_data[:name],
      sku: product_data[:sku],
      description: "High-quality #{category.downcase} - #{product_data[:name]}",
      price: product_data[:price],
      cost: product_data[:cost],
      stock: product_data[:stock],
      supplier: supplier,
      organization: org
    )

    if product.save
      puts "✓ #{product.name} (SKU: #{product.sku}) - L#{sprintf('%.2f', product.price)}"
      products_created += 1
    else
      puts "✗ Failed to create #{product_data[:name]}: #{product.errors.full_messages.join(', ')}"
    end
  end
end

puts "\n=== Summary ==="
puts "✓ Successfully created #{products_created} products"
puts "✓ Total products in system: #{Product.count}"
puts "✓ Products now span multiple categories for better search testing"
puts "\nYou can now test the search functionality with a larger dataset!"
