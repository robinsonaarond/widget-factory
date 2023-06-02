class InlineWidgetComponent < ViewComponent::Base
  def initialize(widget:, expand_url: nil, library_mode: false, error: nil)
    @widget = widget
    @expand_url = expand_url
    @library_mode = library_mode
    @error = error
  end
end
