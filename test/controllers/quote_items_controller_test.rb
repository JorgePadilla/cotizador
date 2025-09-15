require "test_helper"

class QuoteItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quote = quotes(:one)
    @quote_item = quote_items(:one)
    @product = products(:one)
    sign_in_as(users(:one))
  end

  test "should get new" do
    get new_quote_quote_item_url(@quote)
    assert_response :success
    assert_select "h1", "New Quote Item"
  end

  test "should create quote_item" do
    # Create a new quote to avoid interference from fixture data
    quote = Quote.create!(
      quote_number: "QT-202503-997",
      client_id: clients(:one).id,
      organization_id: clients(:one).organization_id,
      status: "draft",
      valid_until: 1.month.from_now
    )

    assert_difference("QuoteItem.count") do
      post quote_quote_items_url(quote), params: {
        quote_item: {
          product_id: @product.id,
          description: "Test product",
          quantity: 2,
          unit_price: 100
        }
      }
    end

    assert_redirected_to quote_url(quote)

    quote.reload
    assert_equal 200, quote.quote_items.last.total
  end

  test "should get edit" do
    get edit_quote_item_url(@quote_item)
    assert_response :success
    assert_select "h1", "Edit Quote Item"
  end

  test "should update quote_item" do
    patch quote_item_url(@quote_item), params: {
      quote_item: {
        quantity: 3,
        unit_price: 120
      }
    }
    assert_redirected_to quote_url(@quote_item.quote)

    @quote_item.reload
    assert_equal 3, @quote_item.quantity
    assert_equal 120, @quote_item.unit_price
    assert_equal 360, @quote_item.total
  end

  test "should destroy quote_item" do
    quote = @quote_item.quote

    assert_difference("QuoteItem.count", -1) do
      delete quote_item_url(@quote_item)
    end

    assert_redirected_to quote_url(quote)
  end
end
