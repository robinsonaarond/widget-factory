class ExpandedWidgetComponent < ViewComponent::Base
  def initialize(widget:, modal_heading: nil)
    @widget = widget
    @modal_heading = modal_heading || widget.name
  end
end
