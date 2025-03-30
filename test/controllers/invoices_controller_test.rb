require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:one)
    @client = clients(:one)
    @user = users(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get invoices_url
    assert_response :success
  end

  test "should get show" do
    get invoice_url(@invoice)
    assert_response :success
  end

  test "should get new" do
    get new_invoice_url
    assert_response :success
  end

  test "should get edit" do
    get edit_invoice_url(@invoice)
    assert_response :success
  end

  test "should create invoice" do
    assert_difference("Invoice.count") do
      post invoices_url, params: { invoice: { invoice_number: "INV-001", client_id: @client.id, subtotal: 100.0, tax: 15.0, total: 115.0, status: "draft", payment_method: "cash" } }
    end
    # Get the actual invoice that was created
    new_invoice = Invoice.find_by(invoice_number: "INV-001")
    assert_redirected_to invoice_url(new_invoice)
  end

  test "should update invoice" do
    patch invoice_url(@invoice), params: { invoice: { subtotal: 200.0 } }
    assert_redirected_to invoice_url(@invoice)
  end

  test "should destroy invoice" do
    assert_difference("Invoice.count", -1) do
      delete invoice_url(@invoice)
    end
    assert_redirected_to invoices_url
  end
end
