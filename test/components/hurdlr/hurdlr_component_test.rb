# frozen_string_literal: true

require "test_helper"

class Hurdlr::HurdlrComponentTest < ViewComponent::TestCase
  def setup
    @widget = Widget.create(name: "Profit + Loss", component: "hurdlr", partner: "Hurdlr")
    @widget.logo.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "logo.png")), filename: "logo.png", content_type: "image/png")
    @error = nil
  end

  def test_component_renders_name
    assert_includes(
      rendered.css("#heading").to_html,
      @widget.name
    )
  end

  def test_component_renders_metrics_table
    # Rows are added via JavaScript, so we will just check for the headers
    table = rendered.css("table").to_html
    assert_includes(table, "Metric")
    assert_includes(table, "Amount")
  end

  def test_component_renders_logo
    assert_includes(
      rendered.css("img#logo").to_html,
      "logo.png"
    )
    assert_includes(
      rendered.css("img#logo").to_html,
      "alt=\"#{@widget.partner}\""
    )
  end

  def test_component_renders_signup
    instance_variable_set(:@error, "subscription not found") do
      assert_includes(
        rendered.to_html,
        "Sign up for Hurdlr"
      )
    end
  end

  def test_component_renders_error
    instance_variable_set(:@error, "unknown error") do
      assert_includes(
        rendered.to_html,
        "Oh no something happened!"
      )
    end
  end

  private

  def rendered
    render_inline(Hurdlr::HurdlrComponent.new(library_mode: true))
  end
end
