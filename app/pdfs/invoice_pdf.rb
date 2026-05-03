require "prawn"
require "prawn/measurement_extensions"
require "prawn/table"

class InvoicePdf < Prawn::Document
  def initialize(invoice, locale = :en)
    super(page_size: "LETTER", margin: 50)
    @invoice = invoice
    @locale = locale
    I18n.locale = @locale
    generate_content
  end

  def generate_content
    if @invoice.fiscal?
      sar_header
      sar_invoice_details
      client_details
      invoice_items_table
      sar_totals
      sar_footer
    else
      header
      invoice_details
      client_details
      invoice_items_table
      totals
      footer
    end
  end

  private

  def header
    # Add company logo if available
    # image "#{Rails.root}/app/assets/images/logo.png", width: 150, position: :left

    # Add organization name and invoice title
    text @invoice.organization.name, size: 24, style: :bold
    move_down 5
    text I18n.t("invoices.invoice").upcase, size: 18, style: :bold
    move_down 20
  end

  def invoice_details
    # Invoice information box
    bounding_box([0, cursor], width: 250) do
      text "#{I18n.t('invoices.attributes.invoice_number')}: #{@invoice.invoice_number}", size: 12
      text "#{I18n.t('invoices.attributes.date')}: #{format_date(@invoice.created_at)}", size: 12
      text "#{I18n.t('invoices.attributes.status')}: #{I18n.t("invoices.statuses.#{@invoice.status}")}", size: 12
      if @invoice.status == "paid"
        payment_method_display = if @invoice.payment_method.present?
                                  if @invoice.payment_method.is_a?(String)
                                    I18n.t("invoices.payment_methods.#{@invoice.payment_method}")
                                  elsif @invoice.payment_method.is_a?(Hash)
                                    # Extract the first key if it's a hash
                                    first_key = @invoice.payment_method.keys.first
                                    I18n.t("invoices.payment_methods.#{first_key}")
                                  else
                                    I18n.t("common.not_available")
                                  end
        else
                                  I18n.t("common.not_available")
        end
        text "#{I18n.t('invoices.attributes.payment_method')}: #{payment_method_display}", size: 12
      end
    end
    move_down 20
  end

  def client_details
    # Client information box
    bounding_box([0, cursor], width: 250) do
      text "#{I18n.t('clients.client_details')}:", size: 14, style: :bold
      move_down 5
      text "#{I18n.t('clients.attributes.name')}: #{@invoice.client.name}", size: 12
      text "#{I18n.t('clients.attributes.rtn')}: #{@invoice.client.rtn}", size: 12
      text "#{I18n.t('clients.attributes.address')}: #{@invoice.client.address}", size: 12
      text "#{I18n.t('clients.attributes.phone')}: #{@invoice.client.phone}", size: 12
      text "#{I18n.t('clients.attributes.email')}: #{@invoice.client.email}", size: 12
    end
    move_down 20
  end

  def invoice_items_table
    # Table header
    text "#{I18n.t('invoices.items')}:", size: 14, style: :bold
    move_down 10

    # Create the items table
    table_data = [ [
      I18n.t("invoices.attributes.description"),
      I18n.t("invoices.quantity"),
      I18n.t("invoices.attributes.unit_price"),
      I18n.t("invoices.attributes.total")
    ] ]

    # Add each invoice item to the table
    @invoice.invoice_items.each do |item|
      table_data << [
        item.product&.name || item.description,
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
      ["#{I18n.t('invoices.attributes.subtotal')}:", format_currency(@invoice.subtotal)],
      ["#{I18n.t('invoices.attributes.tax')}:", format_currency(@invoice.tax)],
      ["#{I18n.t('invoices.attributes.total')}:", format_currency(@invoice.total)]
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
    text I18n.t("invoices.terms_and_conditions"), size: 14, style: :bold
    move_down 5
    text I18n.t("invoices.terms.payment_due"), size: 10
    text I18n.t("invoices.terms.late_payment"), size: 10
    text I18n.t("invoices.terms.include_invoice_number"), size: 10

    # Add page numbers
    number_pages I18n.t("invoices.page_numbers"),
                 { start_count_at: 1, page_filter: :all, at: [bounds.right - 150, 0], align: :right, size: 9 }
  end

  def sar_header
    org = @invoice.organization
    text org.name, size: 18, style: :bold
    text org.nombre_comercial, size: 11 if org.nombre_comercial.present?
    text "RTN: #{org.rtn}", size: 10
    text(org.casa_matriz_address.presence || org.address.to_s, size: 10)
    if @invoice.establishment
      text "#{@invoice.establishment.nombre} — #{@invoice.establishment.address}", size: 9
    end
    move_down 8
    text I18n.t("invoices.sar.kinds.#{@invoice.invoice_kind}"), size: 18, style: :bold
    move_down 12
  end

  def sar_invoice_details
    bounding_box([0, cursor], width: 540) do
      bounding_box([0, cursor], width: 270) do
        text "#{I18n.t('invoices.sar.correlativo')}: #{@invoice.correlativo}", size: 11, style: :bold
        text "#{I18n.t('invoices.attributes.date')}: #{format_date(@invoice.invoice_date || @invoice.created_at)}", size: 10
        if @invoice.original_invoice
          text "#{I18n.t('invoices.sar.original_document')}: #{@invoice.original_invoice.correlativo}", size: 10
        end
      end
      bounding_box([280, cursor + 50], width: 260) do
        cai = @invoice.cai_authorization
        text "#{I18n.t('invoices.sar.cai')}:", size: 9
        text cai.cai, size: 9, style: :bold
        text "#{I18n.t('invoices.sar.fecha_limite')}: #{cai.fecha_limite_emision}", size: 9
        text "#{I18n.t('invoices.sar.rango_autorizado')}: #{cai.rango_inicial} – #{cai.rango_final}", size: 9
      end
    end
    move_down 18
  end

  def sar_totals
    rows = []
    rows << [ "#{I18n.t('invoices.sar.importe_exento')}:", format_currency(@invoice.importe_exento) ]    if @invoice.importe_exento.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.importe_exonerado')}:", format_currency(@invoice.importe_exonerado) ] if @invoice.importe_exonerado.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.gravado_15')}:", format_currency(@invoice.gravado_15) ] if @invoice.gravado_15.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.gravado_18')}:", format_currency(@invoice.gravado_18) ] if @invoice.gravado_18.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.isv_15')}:", format_currency(@invoice.isv_15) ] if @invoice.isv_15.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.isv_18')}:", format_currency(@invoice.isv_18) ] if @invoice.isv_18.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.descuento')}:", format_currency(@invoice.descuento_total) ] if @invoice.descuento_total.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.total_a_pagar')}:", format_currency(@invoice.total) ]

    bounding_box([300, cursor], width: 250) do
      table(rows) do |t|
        t.cell_style = { padding: [ 4, 8, 4, 8 ], borders: [] }
        t.columns(1).align = :right
        t.row(rows.size - 1).font_style = :bold
      end
    end
    move_down 24
  end

  def sar_footer
    move_down 10
    text I18n.t("invoices.sar.legend"), size: 11, style: :italic, align: :center
    number_pages I18n.t("invoices.page_numbers"),
                 { start_count_at: 1, page_filter: :all, at: [ bounds.right - 150, 0 ], align: :right, size: 9 }
  end

  def format_date(date)
    I18n.l(date, format: :long)
  end

  def format_currency(amount)
    return "L0.00" if amount.nil?

    # Use current user's currency preference first, fall back to organization currency
    currency = if Current.user&.currency.present?
                 Current.user.currency
    elsif @invoice.organization&.currency.present?
                 @invoice.organization.currency
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
