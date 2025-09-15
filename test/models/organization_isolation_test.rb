require "test_helper"

class OrganizationIsolationTest < ActiveSupport::TestCase
  test "users should only see their own organization's clients through scoped queries" do
    # Create two organizations
    org1 = Organization.create!(name: "Org 1", currency: "USD", language: "en")
    org2 = Organization.create!(name: "Org 2", currency: "USD", language: "en")
    
    # Create clients for each organization
    client1 = org1.clients.create!(name: "Client 1", rtn: "RTN11111")
    client2 = org2.clients.create!(name: "Client 2", rtn: "RTN22222")
    
    # Test controller-style scoping
    assert_includes org1.clients, client1
    assert_not_includes org1.clients, client2
    
    assert_includes org2.clients, client2
    assert_not_includes org2.clients, client1
  end
  
  test "users should only see their own organization's products through scoped queries" do
    org1 = Organization.create!(name: "Org 1", currency: "USD", language: "en")
    org2 = Organization.create!(name: "Org 2", currency: "USD", language: "en")
    
    # Create a supplier for each org
    supplier1 = org1.suppliers.create!(name: "Supplier 1", rtn: "SUP11111")
    supplier2 = org2.suppliers.create!(name: "Supplier 2", rtn: "SUP22222")
    
    product1 = org1.products.create!(name: "Product 1", sku: "SKU11111", price: 100, supplier: supplier1)
    product2 = org2.products.create!(name: "Product 2", sku: "SKU22222", price: 200, supplier: supplier2)
    
    assert_includes org1.products, product1
    assert_not_includes org1.products, product2
    
    assert_includes org2.products, product2
    assert_not_includes org2.products, product1
  end
  
  test "users should only see their own organization's invoices through scoped queries" do
    org1 = Organization.create!(name: "Org 1", currency: "USD", language: "en")
    org2 = Organization.create!(name: "Org 2", currency: "USD", language: "en")
    
    client1 = org1.clients.create!(name: "Client 1", rtn: "RTN11111")
    client2 = org2.clients.create!(name: "Client 2", rtn: "RTN22222")
    
    invoice1 = org1.invoices.create!(invoice_number: "INV11111", client: client1, total: 100)
    invoice2 = org2.invoices.create!(invoice_number: "INV22222", client: client2, total: 200)
    
    assert_includes org1.invoices, invoice1
    assert_not_includes org1.invoices, invoice2
    
    assert_includes org2.invoices, invoice2
    assert_not_includes org2.invoices, invoice1
  end
end