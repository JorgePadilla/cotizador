class InvoiceFormComponent < ViewComponent::Base
  def initialize(invoice:, clients:)
    @invoice = invoice
    @clients = clients
  end

  private

  attr_reader :invoice, :clients
end
