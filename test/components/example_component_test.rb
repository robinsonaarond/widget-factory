# frozen_string_literal: true

require "test_helper"

class ExampleComponentTest < ViewComponent::TestCase
  def test_component_renders_something_useful
    assert_equal(
      %(<h3>Example Component</h3>),
      render_inline(ExampleComponent.new()).css("h3").to_html
    )
  end
end
