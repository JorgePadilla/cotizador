require "test_helper"

class InvoiceItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get invoice_items_index_url
    assert_response :success
  end

  test "should get show" do
    get invoice_items_show_url
    assert_response :success
  end

  test "should get new" do
    get invoice_items_new_url
    assert_response :success
  end

  test "should get edit" do
    get invoice_items_edit_url
    assert_response :success
  end

  test "should get create" do
    get invoice_items_create_url
    assert_response :success
  end

  test "should get update" do
    get invoice_items_update_url
    assert_response :success
  end

  test "should get destroy" do
    get invoice_items_destroy_url
    assert_response :success
  end
end
