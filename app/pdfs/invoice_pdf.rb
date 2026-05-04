require "prawn"
require "prawn/measurement_extensions"
require "prawn/table"

class InvoicePdf < Prawn::Document
  ISV_PERCENT_LABELS = {
    "gravado_15" => "15%",
    "gravado_18" => "18%",
    "exento"     => "Exento",
    "exonerado"  => "Exonerado"
  }.freeze

  def initialize(invoice, locale = :en)
    super(page_size: "LETTER", margin: 50)
    @invoice = invoice
    @locale = locale
    I18n.locale = @locale
    generate_content
  end

  def generate_content
    if @invoice.fiscal?
      # SAR-compliant layout: render twice (ORIGINAL: CLIENTE / COPIA: EMISOR)
      render_fiscal_copy("ORIGINAL: CLIENTE")
      start_new_page
      render_fiscal_copy("COPIA: EMISOR")
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

  def render_fiscal_copy(copy_label)
    sar_header
    sar_copy_label(copy_label)
    sar_invoice_details
    sar_client_details
    sar_items_table
    sar_totals
    sar_amount_in_words
    sar_footer
  end

  def header
    text @invoice.organization.name, size: 24, style: :bold
    move_down 5
    text I18n.t("invoices.invoice").upcase, size: 18, style: :bold
    move_down 20
  end

  def invoice_details
    bounding_box([ 0, cursor ], width: 250) do
      text "#{I18n.t('invoices.attributes.invoice_number')}: #{@invoice.invoice_number}", size: 12
      text "#{I18n.t('invoices.attributes.date')}: #{format_date(@invoice.created_at)}", size: 12
      text "#{I18n.t('invoices.attributes.status')}: #{I18n.t("invoices.statuses.#{@invoice.status}")}", size: 12
      if @invoice.status == "paid"
        text "#{I18n.t('invoices.attributes.payment_method')}: #{payment_method_display}", size: 12
      end
    end
    move_down 20
  end

  def client_details
    bounding_box([ 0, cursor ], width: 250) do
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
    text "#{I18n.t('invoices.items')}:", size: 14, style: :bold
    move_down 10

    table_data = [ [
      I18n.t("invoices.attributes.description"),
      I18n.t("invoices.quantity"),
      I18n.t("invoices.attributes.unit_price"),
      I18n.t("invoices.attributes.total")
    ] ]
    @invoice.invoice_items.each do |item|
      table_data << [
        item.product&.name || item.description,
        item.quantity.to_s,
        format_currency(item.unit_price),
        format_currency(item.total)
      ]
    end

    table(table_data) do |t|
      t.header = true
      t.cell_style = { padding: [ 5, 10, 5, 10 ] }
      t.row(0).font_style = :bold
      t.row(0).background_color = "DDDDDD"
      t.columns(2..3).align = :right
    end
    move_down 20
  end

  def totals
    totals_data = [
      [ "#{I18n.t('invoices.attributes.subtotal')}:", format_currency(@invoice.subtotal) ],
      [ "#{I18n.t('invoices.attributes.tax')}:", format_currency(@invoice.tax) ],
      [ "#{I18n.t('invoices.attributes.total')}:", format_currency(@invoice.total) ]
    ]
    bounding_box([ 300, cursor ], width: 250) do
      table(totals_data) do |t|
        t.cell_style = { padding: [ 5, 10, 5, 10 ], borders: [] }
        t.columns(1).align = :right
        t.row(2).font_style = :bold
      end
    end
    move_down 30
  end

  def footer
    text I18n.t("invoices.terms_and_conditions"), size: 14, style: :bold
    move_down 5
    text I18n.t("invoices.terms.payment_due"), size: 10
    text I18n.t("invoices.terms.late_payment"), size: 10
    text I18n.t("invoices.terms.include_invoice_number"), size: 10
    number_pages I18n.t("invoices.page_numbers"),
                 { start_count_at: 1, page_filter: :all, at: [ bounds.right - 150, 0 ], align: :right, size: 9 }
  end

  # ── SAR-compliant rendering ────────────────────────────────────────────────

  def sar_header
    org = @invoice.organization
    text org.name, size: 18, style: :bold
    text org.nombre_comercial, size: 11 if org.nombre_comercial.present?
    text "RTN: #{org.rtn}", size: 10
    text(org.casa_matriz_address.presence || org.address.to_s, size: 10)
    contact = [ org.phone, org.email ].compact.reject(&:blank?).join(" · ")
    text contact, size: 9 if contact.present?
    if @invoice.establishment
      text "#{I18n.t('invoices.sar.issuing_establishment')}: #{@invoice.establishment.codigo} — #{@invoice.establishment.nombre}", size: 9
      text @invoice.establishment.address, size: 9 if @invoice.establishment.address.present?
    end
    move_down 8
    text I18n.t("invoices.sar.kinds.#{@invoice.invoice_kind}"), size: 18, style: :bold
    move_down 4
  end

  def sar_copy_label(label)
    text label, size: 10, style: :bold, align: :right, color: "666666"
    move_down 6
  end

  def sar_invoice_details
    cai = @invoice.cai_authorization
    bounding_box([ 0, cursor ], width: 540, height: 90) do
      bounding_box([ 0, cursor ], width: 270) do
        text "#{I18n.t('invoices.sar.correlativo')}: #{@invoice.correlativo}", size: 11, style: :bold
        text "#{I18n.t('invoices.attributes.date')}: #{format_date(@invoice.invoice_date || @invoice.created_at)}", size: 10
        if @invoice.payment_method.present?
          text "#{I18n.t('invoices.attributes.payment_method')}: #{payment_method_display}", size: 10
        end
        if @invoice.original_invoice
          text "#{I18n.t('invoices.sar.original_document')}: #{@invoice.original_invoice.correlativo}", size: 10
        end
      end
      bounding_box([ 280, cursor + 75 ], width: 260) do
        text "#{I18n.t('invoices.sar.cai')}:", size: 9
        text cai.cai, size: 9, style: :bold
        text "#{I18n.t('invoices.sar.fecha_limite')}: #{cai.fecha_limite_emision}", size: 9
        text "#{I18n.t('invoices.sar.rango_autorizado')}: #{cai.rango_inicial} – #{cai.rango_final}", size: 9
      end
    end
    move_down 12
  end

  def sar_client_details
    client = @invoice.client
    text I18n.t("invoices.sar.customer"), size: 10, style: :bold
    text "#{I18n.t('clients.attributes.name')}: #{client.name}", size: 10
    text "RTN: #{client.rtn.presence || I18n.t('common.not_set')}", size: 10
    text "#{I18n.t('clients.attributes.address')}: #{client.address}", size: 10 if client.address.present?
    contact = [ client.phone, client.email ].compact.reject(&:blank?).join(" · ")
    text contact, size: 9 if contact.present?
    if client.exonerado? && client.numero_exoneracion.present?
      text "#{I18n.t('clients.attributes.numero_exoneracion')}: #{client.numero_exoneracion}", size: 9, style: :bold
    end
    if client.agente_retencion?
      text I18n.t("invoices.sar.agente_retencion"), size: 9, style: :bold
    end
    move_down 12
  end

  def sar_items_table
    table_data = [ [
      I18n.t("invoices.attributes.description"),
      I18n.t("invoices.quantity"),
      I18n.t("invoices.attributes.unit_price"),
      "ISV %",
      I18n.t("invoices.attributes.total")
    ] ]
    @invoice.invoice_items.each do |item|
      table_data << [
        item.product&.name || item.description,
        item.quantity.to_s,
        format_currency(item.unit_price),
        ISV_PERCENT_LABELS[item.tipo_isv_resolved || item.product&.tipo_isv || "gravado_15"],
        format_currency(item.total)
      ]
    end

    table(table_data, header: true, width: bounds.width) do |t|
      t.cell_style = { padding: [ 4, 6 ], size: 9 }
      t.row(0).font_style = :bold
      t.row(0).background_color = "DDDDDD"
      t.column(1).align = :right
      t.column(2).align = :right
      t.column(3).align = :center
      t.column(4).align = :right
    end
    move_down 12
  end

  def sar_totals
    rows = []
    rows << [ "#{I18n.t('invoices.sar.importe_exento')}:",    format_currency(@invoice.importe_exento) ]    if @invoice.importe_exento.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.importe_exonerado')}:", format_currency(@invoice.importe_exonerado) ] if @invoice.importe_exonerado.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.gravado_15')}:",        format_currency(@invoice.gravado_15) ]        if @invoice.gravado_15.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.gravado_18')}:",        format_currency(@invoice.gravado_18) ]        if @invoice.gravado_18.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.isv_15')}:",            format_currency(@invoice.isv_15) ]            if @invoice.isv_15.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.isv_18')}:",            format_currency(@invoice.isv_18) ]            if @invoice.isv_18.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.descuento')}:",         format_currency(@invoice.descuento_total) ]   if @invoice.descuento_total.to_f.nonzero?
    rows << [ "#{I18n.t('invoices.sar.total_a_pagar')}:",     format_currency(@invoice.total) ]

    bounding_box([ 300, cursor ], width: 250) do
      table(rows) do |t|
        t.cell_style = { padding: [ 4, 8, 4, 8 ], borders: [] }
        t.columns(1).align = :right
        t.row(rows.size - 1).font_style = :bold
      end
    end
    move_down 12
  end

  def sar_amount_in_words
    text "#{I18n.t('invoices.sar.amount_in_words')}: #{number_to_words(@invoice.total)}", size: 9, style: :italic
    move_down 8
  end

  def sar_footer
    move_down 4
    text I18n.t("invoices.sar.legend"), size: 11, style: :italic, align: :center
    number_pages I18n.t("invoices.page_numbers"),
                 { start_count_at: 1, page_filter: :all, at: [ bounds.right - 150, 0 ], align: :right, size: 9 }
  end

  # ── helpers ────────────────────────────────────────────────────────────────

  def payment_method_display
    return I18n.t("common.not_available") if @invoice.payment_method.blank?

    key = if @invoice.payment_method.is_a?(Hash)
            @invoice.payment_method.keys.first
    else
            @invoice.payment_method
    end
    I18n.t("invoices.payment_methods.#{key}", default: key.to_s)
  end

  def format_date(date)
    I18n.l(date, format: :long)
  end

  def format_currency(amount)
    return "L0.00" if amount.nil?

    currency = @invoice.organization&.currency.presence || Current.user&.currency.presence || "HNL"
    case currency
    when "HNL" then "L #{sprintf('%.2f', amount)}"
    when "EUR" then "€#{sprintf('%.2f', amount)}"
    else            "$#{sprintf('%.2f', amount)}"
    end
  end

  def number_to_words(amount)
    NumberToSpanishWords.call(amount)
  end
end
