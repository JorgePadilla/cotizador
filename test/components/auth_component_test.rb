# frozen_string_literal: true

require "test_helper"

class AuthComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    component = AuthComponent.new(title_text: "Test Title")
    
    # Use the slot API
    component.with_title { "Test Title" }
    component.with_main_content { "Test content" }
    component.with_footer { "Test footer" }
    
    render_inline(component)
    
    assert_text("Test Title")
    assert_text("Test content")
    assert_text("Test footer")
  end
end
