class CreditNotesController < ApplicationController
  before_action :set_credit_note, only: [ :show ]
  before_action :load_clients_and_products, only: [ :new, :create ]

  def new
    original = original_invoice_from_params
    if original.nil?
      redirect_to invoices_path, alert: t("credit_notes.messages.original_required")
      return
    end

    @credit_note = CreditNote.from_invoice(original)
  end

  def create
    @credit_note = CreditNote.new(credit_note_params)
    if @credit_note.save
      redirect_to credit_note_path(@credit_note), notice: t("credit_notes.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  rescue Invoice::SarError => e
    @credit_note ||= CreditNote.new(credit_note_params)
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def show
    @invoice_items = @credit_note.invoice_items.includes(:product)
  end

  private

  def set_credit_note
    @credit_note = current_organization_credit_notes.find(params[:id])
  end

  def current_organization_credit_notes
    Current.organization ? CreditNote.where(organization: Current.organization) : CreditNote.none
  end

  def original_invoice_from_params
    return nil if params[:original_invoice_id].blank? || Current.organization.nil?

    Current.organization.invoices.fiscal.find_by(id: params[:original_invoice_id], invoice_kind: "invoice")
  end

  def load_clients_and_products
    @clients = Current.organization ? Current.organization.clients.order(:name) : Client.none
    @products = Current.organization ? Current.organization.products.order(:name) : Product.none
  end

  def credit_note_params
    params.require(:credit_note).permit(
      :client_id, :original_invoice_id, :descuento_total,
      invoice_items_attributes: [ :id, :product_id, :description, :quantity, :unit_price, :tipo_isv_override, :_destroy ]
    ).merge(organization: Current.organization)
  end
end
