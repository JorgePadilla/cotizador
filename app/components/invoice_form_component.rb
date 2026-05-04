class InvoiceFormComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(invoice:, clients:, current_user: nil, establishments: nil, document_types: nil)
    @invoice = invoice
    @clients = clients
    @current_user = current_user
    @establishments = establishments || []
    @document_types = document_types || []
  end

  def fiscal_mode?
    @establishments.any? && @document_types.any?
  end

  def default_tax_amount
    return 0 unless @current_user&.default_tax

    if @invoice.new_record? && @invoice.tax.nil?
      (@invoice.subtotal || 0) * @current_user.default_tax
    else
      @invoice.tax || 0
    end
  end

  def correlativo_preview
    return nil unless @invoice.cai_authorization

    @invoice.cai_authorization.next_correlativo_preview
  end

  private

  attr_reader :invoice, :clients, :current_user, :establishments, :document_types
end
