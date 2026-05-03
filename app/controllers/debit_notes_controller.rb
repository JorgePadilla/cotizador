class DebitNotesController < ApplicationController
  before_action :set_debit_note, only: [ :show ]
  before_action :load_clients_and_products, only: [ :new, :create ]

  def new
    original = original_invoice_from_params
    if original.nil?
      redirect_to invoices_path, alert: t("debit_notes.messages.original_required")
      return
    end

    @debit_note = DebitNote.from_invoice(original)
  end

  def create
    @debit_note = DebitNote.new(debit_note_params)
    if @debit_note.save
      redirect_to debit_note_path(@debit_note), notice: t("debit_notes.messages.created")
    else
      render :new, status: :unprocessable_entity
    end
  rescue Invoice::SarError => e
    @debit_note ||= DebitNote.new(debit_note_params)
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def show
    @invoice_items = @debit_note.invoice_items.includes(:product)
  end

  private

  def set_debit_note
    @debit_note = current_organization_debit_notes.find(params[:id])
  end

  def current_organization_debit_notes
    Current.organization ? DebitNote.where(organization: Current.organization) : DebitNote.none
  end

  def original_invoice_from_params
    return nil if params[:original_invoice_id].blank? || Current.organization.nil?

    Current.organization.invoices.fiscal.find_by(id: params[:original_invoice_id], invoice_kind: "invoice")
  end

  def load_clients_and_products
    @clients = Current.organization ? Current.organization.clients.order(:name) : Client.none
    @products = Current.organization ? Current.organization.products.order(:name) : Product.none
  end

  def debit_note_params
    params.require(:debit_note).permit(
      :client_id, :original_invoice_id, :descuento_total,
      invoice_items_attributes: [ :id, :product_id, :description, :quantity, :unit_price, :tipo_isv_override, :_destroy ]
    ).merge(organization: Current.organization)
  end
end
