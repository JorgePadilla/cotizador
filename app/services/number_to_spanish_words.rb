class NumberToSpanishWords
  UNITS = %w[cero uno dos tres cuatro cinco seis siete ocho nueve
             diez once doce trece catorce quince dieciséis diecisiete dieciocho diecinueve
             veinte veintiuno veintidós veintitrés veinticuatro veinticinco veintiséis veintisiete veintiocho veintinueve].freeze

  TENS = { 30 => "treinta", 40 => "cuarenta", 50 => "cincuenta", 60 => "sesenta",
           70 => "setenta", 80 => "ochenta", 90 => "noventa" }.freeze

  HUNDREDS = { 100 => "cien", 200 => "doscientos", 300 => "trescientos", 400 => "cuatrocientos",
               500 => "quinientos", 600 => "seiscientos", 700 => "setecientos",
               800 => "ochocientos", 900 => "novecientos" }.freeze

  def self.call(amount, currency_label: "Lempiras", cents_label: "Centavos")
    return "" if amount.nil?

    integer_part = amount.to_i
    cents = ((amount.to_f - integer_part).round(2) * 100).round

    integer_words = under_one_million(integer_part).strip.capitalize
    cents_str = cents.to_s.rjust(2, "0")
    "#{integer_words} #{currency_label} con #{cents_str}/100 #{cents_label}"
  end

  def self.under_one_million(n)
    return "cero" if n.zero?
    return UNITS[n] if n < 30
    return tens_to_words(n) if n < 100
    return hundreds_to_words(n) if n < 1000
    return thousands_to_words(n) if n < 1_000_000

    "[número fuera de rango]"
  end

  def self.tens_to_words(n)
    base = (n / 10) * 10
    rem = n % 10
    rem.zero? ? TENS[base] : "#{TENS[base]} y #{UNITS[rem]}"
  end

  def self.hundreds_to_words(n)
    base = (n / 100) * 100
    rem = n % 100
    label = (n == 100 ? "cien" : (HUNDREDS[base] || "ciento").sub(/^cien$/, "ciento"))
    rem.zero? ? label : "#{label} #{rem < 30 ? UNITS[rem] : tens_to_words(rem)}"
  end

  def self.thousands_to_words(n)
    thousands = n / 1000
    rem = n % 1000
    prefix = thousands == 1 ? "mil" : "#{under_one_thousand_words(thousands)} mil"
    rem.zero? ? prefix : "#{prefix} #{under_one_thousand_words(rem)}"
  end

  def self.under_one_thousand_words(n)
    return "" if n.zero?
    return UNITS[n] if n < 30
    return tens_to_words(n) if n < 100

    hundreds_to_words(n)
  end
end
