class HomeController < ApplicationController
  def index
    if Current.user.organization
      @clients_count = Current.user.organization.clients.count
      @suppliers_count = Current.user.organization.suppliers.count
      @products_count = Current.user.organization.products.count
      @invoices_count = Current.user.organization.invoices.count
      @quotes_count = Current.user.organization.quotes.count

      @recent_invoices = Current.user.organization.invoices.order(created_at: :desc).limit(5)
      @recent_clients = Current.user.organization.clients.order(created_at: :desc).limit(5)
      @recent_quotes = Current.user.organization.quotes.order(created_at: :desc).limit(5)
    else
      @clients_count = 0
      @suppliers_count = 0
      @products_count = 0
      @invoices_count = 0
      @quotes_count = 0

      @recent_invoices = []
      @recent_clients = []
      @recent_quotes = []
    end
  end
end
