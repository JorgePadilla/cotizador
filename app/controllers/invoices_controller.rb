class InvoicesController < ApplicationController
  before_action :set_invoice, only: [ :show, :edit, :update, :destroy ]
  before_action :load_clients_and_products, only: [ :new, :edit, :create, :update ]

  def index
    @invoices = Invoice.includes(:client).order(created_at: :desc)
  end

  def show
    @invoice_items = @invoice.invoice_items.includes(:product)
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_number = generate_invoice_number

    # Pre-select client if provided in params
    @invoice.client_id = params[:client_id] if params[:client_id].present?

    # Initialize with one empty invoice item
    @invoice.invoice_items.build
  end

  def edit
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      redirect_to @invoice, notice: "Invoice was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "Invoice was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_url, notice: "Invoice was successfully destroyed."
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def load_clients_and_products
    @clients = Client.order(:name)
    @products = Product.order(:name)
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
      invoice_items_attributes: [ :id, :product_id, :description, :quantity, :unit_price, :total, :_destroy ]
    )
  end

  def generate_invoice_number
    last_invoice = Invoice.order(created_at: :desc).first
    if last_invoice && last_invoice.invoice_number.match(/\d+$/)
      # Extract the number part and increment
      base = last_invoice.invoice_number.gsub(/\d+$/) { |n| n.to_i + 1 }
    else
      # Start with INV-001
      base = "INV-001"
    end
    base
  end
end
