require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  test "should be valid with all required attributes" do
    client = clients(:one)
    quote = Quote.new(
      client: client,
      valid_until: 1.month.from_now,
      status: "draft"
    )
    assert quote.valid?
  end

  test "should automatically generate quote number" do
    client = clients(:one)
    quote = Quote.create!(
      client: client,
      valid_until: 1.month.from_now,
      status: "draft"
    )
    assert_not_nil quote.quote_number
    assert_match(/QT-\d{6}-\d+/, quote.quote_number)
  end

  test "should calculate totals from quote items" do
    # Create a new quote to avoid interference from fixture data
    quote = Quote.create!(
      quote_number: "QT-202503-999",
      client_id: clients(:one).id,
      status: "draft",
      valid_until: 1.month.from_now
    )
    product = products(:one)

    quote.quote_items.create!(
      product: product,
      description: product.description,
      quantity: 2,
      unit_price: 100
    )

    quote.reload
    assert_equal 200, quote.subtotal
    assert_equal 30, quote.tax # 15% of 200
    assert_equal 230, quote.total
  end

  test "should not be valid without client" do
    quote = Quote.new(
      valid_until: 1.month.from_now,
      status: "draft"
    )
    assert_not quote.valid?
    assert_includes quote.errors[:client], "must exist"
  end

  test "should not be valid without valid_until date" do
    quote = Quote.new(
      client: clients(:one),
      status: "draft"
    )
    assert_not quote.valid?
    assert_includes quote.errors[:valid_until], "can't be blank"
  end

  test "should not be valid with invalid status" do
    quote = Quote.new(
      client: clients(:one),
      valid_until: 1.month.from_now,
      status: "invalid_status"
    )
    assert_not quote.valid?
    assert_includes quote.errors[:status], "is not included in the list"
  end
end
