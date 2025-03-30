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
