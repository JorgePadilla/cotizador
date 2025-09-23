require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @supplier = suppliers(:one)
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get show" do
    get product_url(@product)
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should only show organization suppliers in new product form" do
    # Create a supplier in a different organization
    other_org = Organization.create!(name: "Other Org", currency: "USD")
    other_supplier = Supplier.create!(name: "Other Supplier", rtn: "99999999", organization: other_org)

    get new_product_url
    assert_response :success

    # Verify that only current organization's suppliers are available
    assert_select "option[value='#{other_supplier.id}']", false, "Should not show suppliers from other organizations"

    # Verify that current organization's suppliers are available
    current_org = @user.organization
    current_org_supplier = current_org.suppliers.first
    assert_select "option[value='#{current_org_supplier.id}']", true, "Should show suppliers from current organization"
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { name: "New Product", sku: "SKU123", price: 10.0, cost: 5.0, stock: 10, supplier_id: @supplier.id } }
    end
    # Get the actual product that was created
    new_product = Product.find_by(sku: "SKU123")
    assert_redirected_to product_url(new_product)
  end

  test "should update product" do
    patch product_url(@product), params: { product: { name: "Updated Product" } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end
    assert_redirected_to products_url
  end
end
