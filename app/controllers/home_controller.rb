class HomeController < ApplicationController
  def index
    @clients_count = Current.user.organization.clients.count
    @suppliers_count = Current.user.organization.suppliers.count
    @products_count = Current.user.organization.products.count
    @invoices_count = Current.user.organization.invoices.count
    @quotes_count = Current.user.organization.quotes.count

    @recent_invoices = Current.user.organization.invoices.order(created_at: :desc).limit(5)
    @recent_clients = Current.user.organization.clients.order(created_at: :desc).limit(5)
    @recent_quotes = Current.user.organization.quotes.order(created_at: :desc).limit(5)
  end
end
