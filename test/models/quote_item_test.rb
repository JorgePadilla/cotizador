require "test_helper"

class QuoteItemTest < ActiveSupport::TestCase
  test "should be valid with all required attributes" do
    quote = quotes(:one)
    product = products(:one)
    quote_item = QuoteItem.new(
      quote: quote,
      product: product,
      description: "Test product",
      quantity: 2,
      unit_price: 100
    )
    assert quote_item.valid?
  end

  test "should automatically calculate total" do
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      product: products(:one),
      description: "Test product",
      quantity: 3,
      unit_price: 50
    )
    quote_item.calculate_total
    assert_equal 150, quote_item.total
  end

  test "should set details from product when blank" do
    product = products(:one)
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      product: product,
      quantity: 1
    )
    quote_item.valid? # Triggers callbacks
    assert_equal product.description, quote_item.description
    assert_equal product.price, quote_item.unit_price
  end

  test "should not be valid without quantity" do
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      product: products(:one),
      description: "Test product",
      unit_price: 100
    )
    assert_not quote_item.valid?
    assert_includes quote_item.errors[:quantity], "can't be blank"
  end

  test "should not be valid with negative quantity" do
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      product: products(:one),
      description: "Test product",
      quantity: -1,
      unit_price: 100
    )
    assert_not quote_item.valid?
    assert_includes quote_item.errors[:quantity], "must be greater than 0"
  end

  test "should not be valid without unit price" do
    # Create a quote item without using a product to avoid the callback
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      description: "Test product",
      quantity: 1
    )
    # Skip the callback that would set the unit_price from product
    quote_item.product_id = nil
    quote_item.unit_price = nil
    assert_not quote_item.valid?
    assert_includes quote_item.errors[:unit_price], "can't be blank"
  end

  test "should not be valid with negative unit price" do
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      product: products(:one),
      description: "Test product",
      quantity: 1,
      unit_price: -10
    )
    assert_not quote_item.valid?
    assert_includes quote_item.errors[:unit_price], "must be greater than or equal to 0"
  end

  test "should update quote totals after save" do
    # Create a new quote to avoid interference from fixture data
    quote = Quote.create!(
      quote_number: "QT-202503-998",
      client_id: clients(:one).id,
      organization_id: organizations(:default_organization).id,
      status: "draft",
      valid_until: 1.month.from_now
    )

    QuoteItem.create!(
      quote: quote,
      product: products(:one),
      description: "Test product",
      quantity: 2,
      unit_price: 100
    )

    quote.reload
    assert_equal 200, quote.subtotal
    assert_equal 30, quote.tax # 15% of 200
    assert_equal 230, quote.total
  end
end
