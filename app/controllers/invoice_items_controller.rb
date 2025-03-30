class InvoiceItemsController < ApplicationController
  before_action :set_invoice, only: [ :index, :new, :create ]
  before_action :set_invoice_item, only: [ :show, :edit, :update, :destroy ]

  def index
    @invoice_items = @invoice.invoice_items
  end

  def show
  end

  def new
    @invoice_item = @invoice.invoice_items.build
  end

  def edit
  end

  def create
    @invoice_item = @invoice.invoice_items.build(invoice_item_params)

    if @invoice_item.save
      redirect_to invoice_url(@invoice), notice: "Invoice item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @invoice_item.update(invoice_item_params)
      redirect_to invoice_url(@invoice_item.invoice), notice: "Invoice item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    invoice = @invoice_item.invoice
    @invoice_item.destroy
    redirect_to invoice_url(invoice), notice: "Invoice item was successfully destroyed."
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:invoice_id])
  end

  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end

  def invoice_item_params
    params.require(:invoice_item).permit(:product_id, :description, :quantity, :unit_price)
  end
end
