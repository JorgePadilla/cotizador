require 'prawn'
require 'prawn/measurement_extensions'

class QuotePdf < Prawn::Document
  def initialize(quote)
    super(page_size: "LETTER", margin: 50)
    @quote = quote
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
    
    # Add company name and quote title
    text "Cotizador", size: 24, style: :bold
    move_down 5
    text "QUOTE", size: 18, style: :bold
    move_down 20
  end

  def quote_details
    # Quote information box
    bounding_box([0, cursor], width: 250) do
      text "Quote Number: #{@quote.quote_number}", size: 12
      text "Date: #{@quote.created_at.strftime('%B %d, %Y')}", size: 12
      text "Valid Until: #{@quote.valid_until.strftime('%B %d, %Y')}", size: 12
      text "Status: #{@quote.status.capitalize}", size: 12
    end
    move_down 20
  end

  def client_details
    # Client information box
    bounding_box([0, cursor], width: 250) do
      text "Client Information:", size: 14, style: :bold
      move_down 5
      text "Name: #{@quote.client.name}", size: 12
      text "RTN: #{@quote.client.rtn}", size: 12
      text "Address: #{@quote.client.address}", size: 12
      text "Phone: #{@quote.client.phone}", size: 12
      text "Email: #{@quote.client.email}", size: 12
    end
    move_down 20
  end

  def quote_items_table
    # Table header
    text "Items:", size: 14, style: :bold
    move_down 10
    
    # Create the items table
    table_data = [["Description", "Quantity", "Unit Price", "Total"]]
    
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
      ["Subtotal:", format_currency(@quote.subtotal)],
      ["Tax (15%):", format_currency(@quote.tax)],
      ["Total:", format_currency(@quote.total)]
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
    text "Terms and Conditions:", size: 14, style: :bold
    move_down 5
    text "1. This quote is valid until the date specified above.", size: 10
    text "2. Payment terms: 50% advance payment, 50% upon delivery.", size: 10
    text "3. Delivery time: 2-3 weeks after confirmation.", size: 10
    
    # Add page numbers
    number_pages "Page <page> of <total>",
                 { start_count_at: 1, page_filter: :all, at: [bounds.right - 150, 0], align: :right, size: 9 }
  end

  def format_currency(amount)
    "$#{sprintf('%.2f', amount)}"
  end
end
