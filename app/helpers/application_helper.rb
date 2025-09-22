module ApplicationHelper
  def format_currency(amount)
    return number_to_currency(amount) unless Current.user

    case Current.user.currency
    when "HNL"
      number_to_currency(amount, unit: "L", format: "%u%n")
    when "EUR"
      number_to_currency(amount, unit: "€", format: "%n %u")
    else # USD
      number_to_currency(amount, unit: "$", format: "%u%n")
    end
  end
end
