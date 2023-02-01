# frozen_string_literal: true

class WidgetPanel::WidgetPanelComponent < ViewComponent::Base
  def before_render
    @active_widgets = Widget.activated_widgets.where(internal: false)
    @user_uuid = session[:current_user][:uuid]
    @user_widgets = UserWidget.where(user_uuid: session[:current_user][:uuid])
      .where(widgets: Widget.activated_widgets)
      .joins(:widget)
      .rank(:row_order)
  end
end
