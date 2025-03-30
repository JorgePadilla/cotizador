require "test_helper"

class InvoiceItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:one)
    @invoice_item = invoice_items(:one)
    @product = products(:one)
  end
  
  test "should get index" do
    get invoice_invoice_items_url(@invoice)
    assert_response :success
  end

  test "should get show" do
    get invoice_invoice_item_url(@invoice, @invoice_item)
    assert_response :success
  end

  test "should get new" do
    get new_invoice_invoice_item_url(@invoice)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_invoice_item_url(@invoice, @invoice_item)
    assert_response :success
  end

  test "should create invoice_item" do
    assert_difference("InvoiceItem.count") do
      post invoice_invoice_items_url(@invoice), params: { invoice_item: { product_id: @product.id, quantity: 2, unit_price: 10.0, total: 20.0 } }
    end
    assert_redirected_to invoice_url(@invoice)
  end

  test "should update invoice_item" do
    patch invoice_invoice_item_url(@invoice, @invoice_item), params: { invoice_item: { quantity: 3 } }
    assert_redirected_to invoice_url(@invoice)
  end

  test "should destroy invoice_item" do
    assert_difference("InvoiceItem.count", -1) do
      delete invoice_invoice_item_url(@invoice, @invoice_item)
    end
    assert_redirected_to invoice_url(@invoice)
  end
end
