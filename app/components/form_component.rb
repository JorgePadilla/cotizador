# frozen_string_literal: true

class FormComponent < ApplicationComponent
  renders_one :header
  renders_one :form_content
  renders_one :footer
  
  def initialize(resource: nil, url: nil, method: :post, html_options: {})
    @resource = resource
    @url = url
    @method = method
    @html_options = { class: "space-y-6", **html_options }
  end
  
  def form_with_options
    if @resource.present?
      { model: @resource, **@html_options }
    else
      { url: @url, method: @method, **@html_options }
    end
  end
end
