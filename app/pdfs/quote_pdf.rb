require "prawn"
require "prawn/measurement_extensions"

class QuotePdf < Prawn::Document
  def initialize(quote, locale = :en)
    super(page_size: "LETTER", margin: 50)
    @quote = quote
    @locale = locale
    I18n.locale = @locale
    generate_content
  end

  def generate_content
    # Add the company logo and header
    header

    # Add quote information
    quote_details

    # Add client information
    client_details

    # Add quote items table
    quote_items_table

    # Add totals
    totals

    # Add footer with terms and conditions
    footer
  end

  private

  def header
    # Add company logo if available
    # image "#{Rails.root}/app/assets/images/logo.png", width: 150, position: :left

    # Add organization name and quote title
    text @quote.organization.name, size: 24, style: :bold
    move_down 5
    text I18n.t("quotes.title").upcase, size: 18, style: :bold
    move_down 20
  end

  def quote_details
    # Quote information box
    bounding_box([0, cursor], width: 250) do
      text "#{I18n.t('quotes.attributes.quote_number')}: #{@quote.quote_number}", size: 12
      text "#{I18n.t('quotes.attributes.date')}: #{format_date(@quote.created_at)}", size: 12
      text "#{I18n.t('quotes.attributes.valid_until')}: #{format_date(@quote.valid_until)}", size: 12
      text "#{I18n.t('quotes.attributes.status')}: #{I18n.t("quotes.statuses.#{@quote.status}")}", size: 12
    end
    move_down 20
  end

  def client_details
    # Client information box
    bounding_box([0, cursor], width: 250) do
      text "#{I18n.t('clients.client_details')}:", size: 14, style: :bold
      move_down 5
      text "#{I18n.t('clients.attributes.name')}: #{@quote.client.name}", size: 12
      text "#{I18n.t('clients.attributes.rtn')}: #{@quote.client.rtn}", size: 12
      text "#{I18n.t('clients.attributes.address')}: #{@quote.client.address}", size: 12
      text "#{I18n.t('clients.attributes.phone')}: #{@quote.client.phone}", size: 12
      text "#{I18n.t('clients.attributes.email')}: #{@quote.client.email}", size: 12
    end
    move_down 20
  end

  def quote_items_table
    # Table header
    text "#{I18n.t('quotes.items')}:", size: 14, style: :bold
    move_down 10

    # Create the items table
    table_data = [ [
      I18n.t('quotes.attributes.description'),
      I18n.t('quotes.quantity'),
      I18n.t('quotes.attributes.unit_price'),
      I18n.t('quotes.attributes.total')
    ] ]

    # Add each quote item to the table
    @quote.quote_items.each do |item|
      table_data << [
        item.description,
        item.quantity.to_s,
        format_currency(item.unit_price),
        format_currency(item.total)
      ]
    end

    # Draw the table
    table(table_data) do |t|
      t.header = true
      t.cell_style = { padding: [5, 10, 5, 10] }
      t.row(0).font_style = :bold
      t.row(0).background_color = "DDDDDD"
      t.columns(2..3).align = :right
    end

    move_down 20
  end

  def totals
    # Create a table for the totals
    totals_data = [
      ["#{I18n.t('quotes.attributes.subtotal')}:", format_currency(@quote.subtotal)],
      ["#{I18n.t('quotes.attributes.tax')}:", format_currency(@quote.tax)],
      ["#{I18n.t('quotes.attributes.total')}:", format_currency(@quote.total)]
    ]

    # Draw the totals table aligned to the right
    bounding_box([300, cursor], width: 250) do
      table(totals_data) do |t|
        t.cell_style = { padding: [5, 10, 5, 10], borders: [] }
        t.columns(1).align = :right
        t.row(2).font_style = :bold
      end
    end

    move_down 30
  end

  def footer
    # Add terms and conditions
    text I18n.t('quotes.terms_and_conditions'), size: 14, style: :bold
    move_down 5
    text I18n.t('quotes.terms.valid_until'), size: 10
    text I18n.t('quotes.terms.payment_terms'), size: 10
    text I18n.t('quotes.terms.delivery_time'), size: 10

    # Add page numbers
    number_pages I18n.t('quotes.page_numbers'),
                 { start_count_at: 1, page_filter: :all, at: [bounds.right - 150, 0], align: :right, size: 9 }
  end

  def format_date(date)
    I18n.l(date, format: :long)
  end

  def format_currency(amount)
    return "L0.00" if amount.nil?

    # Use current user's currency preference first, fall back to organization currency
    currency = if Current.user&.currency.present?
                 Current.user.currency
               elsif @quote.organization&.currency.present?
                 @quote.organization.currency
               else
                 "USD"
               end

    case currency
    when "HNL"
      "L#{sprintf('%.2f', amount)}"
    when "EUR"
      "€#{sprintf('%.2f', amount)}"
    else # USD or nil
      "$#{sprintf('%.2f', amount)}"
    end
  end
end
