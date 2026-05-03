# frozen_string_literal: true

class SearchComponent < ViewComponent::Base
  def initialize(resource_name:, placeholder: nil, turbo_frame: nil)
    @resource_name = resource_name
    @placeholder = placeholder || I18n.t("actions.search")
    @turbo_frame = turbo_frame || resource_name
  end

  private

  attr_reader :resource_name, :placeholder, :turbo_frame

  def search_path
    case resource_name
    when "clients"
      clients_path
    when "suppliers"
      suppliers_path
    when "products"
      products_path
    when "invoices"
      invoices_path
    when "quotes"
      quotes_path
    else
      "#"
    end
  end

  def current_search_term
    params[:search]
  end
end
