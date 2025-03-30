require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quote = quotes(:one)
    @client = clients(:one)
    sign_in_as(users(:one))
  end

  test "should get index" do
    get quotes_url
    assert_response :success
    assert_select "h1", "Quotes"
  end

  test "should get new" do
    get new_quote_url
    assert_response :success
    assert_select "h1", "New Quote"
  end

  test "should create quote" do
    assert_difference("Quote.count") do
      post quotes_url, params: {
        quote: {
          client_id: @client.id,
          valid_until: 1.month.from_now.to_date,
          status: "draft"
        }
      }
    end

    # Get the newly created quote and assert the redirect to its URL
    quote = Quote.order(created_at: :desc).first
    assert_redirected_to quote_url(quote)
    assert_equal @client.id, quote.client_id
    assert_equal "draft", quote.status
  end

  test "should show quote" do
    get quote_url(@quote)
    assert_response :success
    assert_select "h1", "Quote #{@quote.quote_number}"
  end

  test "should get edit" do
    get edit_quote_url(@quote)
    assert_response :success
    assert_select "h1", "Edit Quote"
  end

  test "should update quote" do
    patch quote_url(@quote), params: {
      quote: {
        status: "sent",
        valid_until: 2.months.from_now.to_date
      }
    }
    assert_redirected_to quote_url(@quote)

    @quote.reload
    assert_equal "sent", @quote.status
  end

  test "should destroy quote" do
    assert_difference("Quote.count", -1) do
      delete quote_url(@quote)
    end

    assert_redirected_to quotes_url
  end
end
