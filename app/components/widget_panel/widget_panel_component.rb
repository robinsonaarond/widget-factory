# frozen_string_literal: true

class WidgetPanel::WidgetPanelComponent < ViewComponent::Base
  def before_render
    @active_widgets = ["hurdlr", "list_trac"] # TODO: Get widgets that admin has made active
    user_widgets = ["hurdlr", "list_trac"] # TODO: Get widgets for current user
    @user_widgets = user_widgets.select { |w| @active_widgets.include? w } # This can probably be done in the query eventually
  end
end
