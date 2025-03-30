# frozen_string_literal: true

require "test_helper"

class ApplicationComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    render_inline(ApplicationComponent.new)
    assert_selector("div") # Just checking that it renders a div element
  end
end
