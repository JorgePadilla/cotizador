module ApplicationHelper
  def format_currency(amount, organization = nil)
    # Use user's currency preference for the current organization, or fall back to organization currency
    currency = if Current.user&.currency.present?
                  Current.user.currency
    elsif organization&.currency.present?
                  organization.currency
    elsif Current.organization&.currency.present?
                  Current.organization.currency
    else
                  "USD"
    end

    case currency
    when "HNL"
      number_to_currency(amount, unit: "L", format: "%u%n", separator: ".", delimiter: ",")
    when "EUR"
      number_to_currency(amount, unit: "€", format: "%n %u", separator: ".", delimiter: ",")
    else # USD
      number_to_currency(amount, unit: "$", format: "%u%n", separator: ".", delimiter: ",")
    end
  end
end
