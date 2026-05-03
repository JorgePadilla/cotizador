require_relative "../pdfs/invoice_pdf"

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [ :show, :edit, :update, :destroy, :pdf ]
  before_action :load_clients_and_products, only: [ :new, :edit, :create, :update ]
  before_action :load_fiscal_collections, only: [ :new, :edit, :create, :update ]

  def index
    @invoices = Current.organization ? Current.organization.invoices.includes(:client).order(created_at: :desc) : Invoice.none

    if params[:search].present?
      @invoices = @invoices.where("invoice_number ILIKE ? OR clients.name ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  end

  def show
    @invoice_items = @invoice.invoice_items.includes(:product)
  end

  def new
    @invoice = Invoice.new(organization: Current.organization)

    if Current.organization&.fiscal_enabled?
      assign_fiscal_defaults(@invoice)
    else
      @invoice.invoice_number = generate_invoice_number
    end

    @invoice.client_id = params[:client_id] if params[:client_id].present?
    @invoice.invoice_items.build
  end

  def edit
    if @invoice.immutable?
      flash.now[:alert] = t("invoices.sar.immutable_warning")
    end
  end

  def create
    @invoice = Invoice.new(invoice_params.merge(organization: Current.organization))
    if Current.organization&.fiscal_enabled? && @invoice.cai_authorization_id.blank?
      assign_fiscal_defaults(@invoice)
    end

    if @invoice.save
      redirect_to @invoice, notice: t("invoices.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  rescue Invoice::SarError => e
    @invoice ||= Invoice.new(organization: Current.organization)
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: t("invoices.messages.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @invoice.fiscal?
      redirect_to new_credit_note_path(original_invoice_id: @invoice.id),
                  alert: t("invoices.sar.cannot_destroy_create_credit_note")
      return
    end

    @invoice.destroy
    redirect_to invoices_url, notice: t("invoices.messages.deleted")
  end

  def pdf
    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(@invoice, I18n.locale)
        send_data pdf.render,
                  filename: "invoice-#{@invoice.invoice_number}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  def add_item
    @invoice = Invoice.new
    @invoice.invoice_items.build
    @item_index = params[:index].to_i

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_invoice
    @invoice = Current.organization.invoices.find(params[:id])
  end

  def load_clients_and_products
    @clients = Current.organization ? Current.organization.clients.order(:name) : Client.none
    @products = Current.organization ? Current.organization.products.order(:name) : Product.none
  end

  def load_fiscal_collections
    return unless Current.organization

    @establishments = Current.organization.establishments.active.includes(emission_points: :cai_authorizations).order(:codigo)
    @document_types = DocumentType.where(code: [ DocumentType::INVOICE ]).order(:code)
  end

  def invoice_params
    params.require(:invoice).permit(
      :invoice_number,
      :client_id,
      :subtotal,
      :tax,
      :total,
      :status,
      :payment_method,
      :establishment_id,
      :emission_point_id,
      :document_type_id,
      :cai_authorization_id,
      :descuento_total,
      invoice_items_attributes: [ :id, :product_id, :description, :quantity, :unit_price, :total, :tipo_isv_override, :_destroy ]
    )
  end

  def assign_fiscal_defaults(invoice)
    invoice.document_type ||= DocumentType.invoice
    invoice.establishment ||= Current.organization.establishments.active.first
    invoice.emission_point ||= invoice.establishment&.emission_points&.active&.first
    invoice.cai_authorization ||= invoice.emission_point&.active_cai_for(invoice.document_type)
  end

  def generate_invoice_number
    last_invoice = Current.organization ? Current.organization.invoices.legacy.order(created_at: :desc).first : nil
    if last_invoice && last_invoice.invoice_number.match(/\d+$/)
      last_invoice.invoice_number.gsub(/\d+$/) { |n| n.to_i + 1 }
    else
      "INV-001"
    end
  end
end
