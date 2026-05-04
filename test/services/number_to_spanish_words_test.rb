require "test_helper"
require_relative "../../app/services/number_to_spanish_words"

class NumberToSpanishWordsTest < ActiveSupport::TestCase
  test "small integers" do
    assert_equal "Cero Lempiras con 00/100 Centavos", NumberToSpanishWords.call(0)
    assert_equal "Uno Lempiras con 50/100 Centavos", NumberToSpanishWords.call(1.50)
    assert_equal "Quince Lempiras con 00/100 Centavos", NumberToSpanishWords.call(15)
  end

  test "tens" do
    assert_equal "Cuarenta y dos Lempiras con 00/100 Centavos", NumberToSpanishWords.call(42)
    assert_equal "Veinticinco Lempiras con 99/100 Centavos", NumberToSpanishWords.call(25.99)
  end

  test "hundreds" do
    assert_equal "Cien Lempiras con 00/100 Centavos", NumberToSpanishWords.call(100)
    assert_equal "Quinientos cincuenta Lempiras con 75/100 Centavos", NumberToSpanishWords.call(550.75)
  end

  test "thousands" do
    assert_equal "Mil Lempiras con 00/100 Centavos", NumberToSpanishWords.call(1000)
    assert_match(/Tres mil/, NumberToSpanishWords.call(3450))
  end
end
