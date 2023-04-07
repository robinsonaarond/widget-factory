# frozen_string_literal: true

require "test_helper"

class ListTrac::ListTracComponentTest < ViewComponent::TestCase
  def setup
    @widget = Widget.create(
      name: "Online Activity",
      component: "list_trac",
      partner: "ListTrac",
      logo_link_url: "https://moxiworks.com"
    )
    @widget.logo.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "logo.png")), filename: "logo.png", content_type: "image/png")
    @token = nil
    @error = nil
  end

  # Inline component tests

  def test_inline_component_renders_name
    with_inline_component do
      assert_includes(
        rendered.to_html,
        @widget.name
      )
    end
  end

  def test_inline_component_renders_listing_table
    with_inline_component do
      with_listings do
        table = rendered.css("table").to_html
        rows = table.scan(/<tr>/).count
        assert_equal(3, rows)
        header_row = table.split("<tr>")[1]
        assert_includes(header_row, "Address")
        assert_includes(header_row, "Views")
        assert_includes(header_row, "Leads")
        second_row = table.split("<tr>")[2]
        assert_includes(second_row, "123 Main St")
        assert_includes(second_row, "100")
        assert_includes(second_row, "10")
        third_row = table.split("<tr>")[3]
        assert_includes(third_row, "456 Main St")
        assert_includes(third_row, "200")
        assert_includes(third_row, "20")
      end
    end
  end

  def test_inline_component_renders_logo
    with_inline_component do
      assert_includes(
        rendered.css("img#logo").to_html,
        "logo.png"
      )
      assert_includes(
        rendered.css("img#logo").to_html,
        "alt=\"#{@widget.partner}\""
      )
    end
  end

  def test_inline_component_renders_error
    with_inline_component do
      instance_variable_set(:@error, "unknown error") do
        assert_includes(
          rendered.to_html,
          "Oh no something happened!"
        )
      end
    end
  end

  # Expanded component tests
  # The table is generated with JavaScript, so we can't test it here

  def test_expanded_component_renders_name_in_header
    with_expanded_component do
      assert_includes(
        rendered.css("[slot='header-left']").to_html,
        @widget.name
      )
    end
  end

  def test_expanded_component_renders_logo_link
    with_expanded_component do
      assert_includes(
        rendered.css("[slot='footer-left'] a").to_html,
        @widget.logo_link_url
      )
    end
  end

  def test_expanded_component_renders_logo
    with_expanded_component do
      assert_includes(
        rendered.css("[slot='footer-left'] img").to_html,
        "logo.png"
      )
      assert_includes(
        rendered.css("[slot='footer-left'] img").to_html,
        "alt=\"#{@widget.partner}\""
      )
    end
  end

  private

  def rendered
    render_inline(ListTrac::ListTracComponent.new(library_mode: true))
  end

  def with_inline_component
    with_request_url "/component/list_trac/12345" do
      yield
    end
  end

  def with_expanded_component
    with_request_url "/component/list_trac/expanded/12345" do
      yield
    end
  end

  def with_listings
    instance_variable_set(:@listings, [
      {
        address: "123 Main St",
        views: 100,
        leads: 10
      },
      {
        address: "456 Main St",
        views: 200,
        leads: 20
      }
    ]) do
      yield
    end
  end
end
