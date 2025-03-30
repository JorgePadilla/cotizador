require "test_helper"

class SuppliersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier = suppliers(:one)
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get suppliers_url
    assert_response :success
  end

  test "should get show" do
    get supplier_url(@supplier)
    assert_response :success
  end

  test "should get new" do
    get new_supplier_url
    assert_response :success
  end

  test "should get edit" do
    get edit_supplier_url(@supplier)
    assert_response :success
  end

  test "should create supplier" do
    assert_difference("Supplier.count") do
      post suppliers_url, params: { supplier: { name: "New Supplier", rtn: "12345678", email: "supplier@example.com", contact_name: "Contact Person", phone: "12345678" } }
    end
    # Get the actual supplier that was created
    new_supplier = Supplier.find_by(rtn: "12345678")
    assert_redirected_to supplier_url(new_supplier)
  end

  test "should update supplier" do
    patch supplier_url(@supplier), params: { supplier: { name: "Updated Supplier" } }
    assert_redirected_to supplier_url(@supplier)
  end

  test "should destroy supplier" do
    assert_difference("Supplier.count", -1) do
      delete supplier_url(@supplier)
    end
    assert_redirected_to suppliers_url
  end
end
