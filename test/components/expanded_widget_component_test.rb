# frozen_string_literal: true

require "test_helper"

class ExpandedWidgetComponentTest < ViewComponent::TestCase
  def setup
    @widget = Widget.new(
      name: "Test Widget",
      component: "test_widget",
      partner: "MoxiWorks",
      logo_link_url: "https://moxiworks.com"
    )
    @widget.logo.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "logo.png")), filename: "logo.png", content_type: "image/png")
  end

  def test_component_renders_content
    render_inline(ExpandedWidgetComponent.new(widget: @widget)) { "Content" }
    assert_text "Content"
  end

  def test_component_renders_default_heading
    render_inline(ExpandedWidgetComponent.new(widget: @widget))
    assert_selector "[slot='header-left']", text: @widget[:name]
  end

  def test_component_renders_custom_heading
    render_inline(ExpandedWidgetComponent.new(widget: @widget, modal_heading: "Custom Heading"))
    assert_selector "[slot='header-left']", text: "Custom Heading"
  end

  def test_component_renders_logo
    render_inline(ExpandedWidgetComponent.new(widget: @widget))
    assert_selector("img#logo[src*='logo.png'][alt='#{@widget[:partner]}']")
  end

  def test_component_render_logo_link
    render_inline(ExpandedWidgetComponent.new(widget: @widget))
    assert_selector("a[href='#{@widget[:logo_link_url]}']")
  end
end
