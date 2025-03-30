# frozen_string_literal: true

require "test_helper"

class FormComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    component = FormComponent.new(url: "/test", method: :post)
    
    # Use the slot API
    component.with_form_content { "Form content" }
    
    render_inline(component)
    assert_selector("form") # Checking that it renders a form element
    assert_text("Form content")
  end
end
