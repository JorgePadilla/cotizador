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
    quote_item = QuoteItem.new(
      quote: quotes(:one),
      product: products(:one),
      description: "Test product",
      quantity: 1
    )
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
    quote = quotes(:one)
    quote.update(subtotal: 0, tax: 0, total: 0)

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
