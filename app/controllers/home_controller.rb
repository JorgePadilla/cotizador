class HomeController < ApplicationController
  def index
    @clients_count = Client.count
    @suppliers_count = Supplier.count
    @products_count = Product.count
    @invoices_count = Invoice.count

    @recent_invoices = Invoice.order(created_at: :desc).limit(5)
    @recent_clients = Client.order(created_at: :desc).limit(5)
  end
end
