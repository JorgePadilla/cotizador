class InvoiceFormComponent < ViewComponent::Base
  def initialize(invoice:, clients:, current_user: nil)
    @invoice = invoice
    @clients = clients
    @current_user = current_user
  end

  def default_tax_amount
    return 0 unless @current_user&.default_tax

    # If invoice is new and has no tax set, use the user's default
    if @invoice.new_record? && @invoice.tax.nil?
      (@invoice.subtotal || 0) * @current_user.default_tax
    else
      @invoice.tax || 0
    end
  end

  private

  attr_reader :invoice, :clients, :current_user
end
