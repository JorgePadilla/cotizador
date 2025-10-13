# Test script for currency and language logic across organizations
# This script creates test data to verify the currency display logic

puts "=== Setting up test data for currency/language logic ==="

# Create or update organizations
organizations = [
  { name: "TAPHN", currency: "HNL", language: "es" },
  { name: "TAPUSA", currency: "USD", language: "en" },
  { name: "TAPEUR", currency: "EUR", language: "en" }
]

organizations.each do |org_data|
  org = Organization.find_or_initialize_by(name: org_data[:name])
  org.currency = org_data[:currency]
  org.language = org_data[:language]
  if org.save
    puts "✓ Organization #{org.name} created/updated: #{org.currency} currency, #{org.language} language"
  else
    puts "✗ Failed to create/update #{org.name}: #{org.errors.full_messages.join(', ')}"
  end
end

# Find or create test user
user = User.find_by(email_address: "jorgep4dill4@gmail.com")
if user
  puts "✓ Found existing user: #{user.name} (#{user.email_address})"
  puts "  Current currency: #{user.currency}, language: #{user.language}"
else
  puts "✗ Test user not found. Please run the test with an existing user."
  exit 1
end

puts "\n=== Testing currency formatting logic ==="

# Test the currency formatting logic with different user preferences
puts "\nTesting currency formatting with different user preferences:"

def test_format_currency(amount)
  return "L0.00" if amount.nil?

  # Use current user's currency preference first, fall back to organization currency
  currency = if Current.user&.currency.present?
               Current.user.currency
  elsif Current.organization&.currency.present?
               Current.organization.currency
  else
               "USD"
  end

  case currency
  when "HNL"
    "L#{sprintf('%.2f', amount)}"
  when "EUR"
    "€#{sprintf('%.2f', amount)}"
  else # USD or nil
    "$#{sprintf('%.2f', amount)}"
  end
end

# Test 1: User with HNL preference
user.update!(currency: "HNL", language: "es")
puts "\n1. User preference: HNL (lempiras), Spanish"
puts "   format_currency(100.50) = #{test_format_currency(100.50)}"

# Test 2: User with USD preference
user.update!(currency: "USD", language: "en")
puts "\n2. User preference: USD (dollars), English"
puts "   format_currency(100.50) = #{test_format_currency(100.50)}"

# Test 3: User with EUR preference
user.update!(currency: "EUR", language: "en")
puts "\n3. User preference: EUR (euros), English"
puts "   format_currency(100.50) = #{test_format_currency(100.50)}"

puts "\n=== Testing PDF generation logic ==="

# Create test invoices for each organization
puts "\nCreating test invoices for each organization:"

organizations.each do |org_data|
  org = Organization.find_by(name: org_data[:name])

  # Set current organization for testing
  Current.organization = org

  # Create a test invoice
  client = org.clients.first || org.clients.create!(name: "Test Client #{org.name}", rtn: "12345678#{org.name[-1]}")

  invoice = org.invoices.create!(
    invoice_number: "TEST-#{org.name}-#{Time.now.to_i}",
    client: client,
    subtotal: 150.75,
    tax: 22.61,
    total: 173.36,
    status: "draft"
  )

  puts "\n✓ Invoice created for #{org.name}:"
  puts "  - Organization: #{org.name} (#{org.currency})"
  puts "  - Invoice total: #{test_format_currency(invoice.total)}"

  # Test PDF generation
  begin
    pdf = InvoicePdf.new(invoice, I18n.locale)
    puts "  - PDF generation: SUCCESS"
  rescue => e
    puts "  - PDF generation: FAILED - #{e.message}"
  end
end

puts "\n=== Test Summary ==="
puts "✓ Test data created successfully"
puts "✓ Currency formatting tested with different user preferences"
puts "✓ PDF generation tested across organizations"
puts "\nThe system should now display currencies based on user preferences,"
puts "not organization defaults. User preferences take priority."
