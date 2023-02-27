# frozen_string_literal: true

class WidgetPanel::WidgetPanelComponent < ViewComponent::Base
  def before_render
    permitted_components = params[:components].split(",").map(&:to_sym)
    @active_widgets = Widget.activated_widgets.where(internal: false, component: permitted_components)
    @user_uuid = session[:current_user][:uuid]
    @user_widgets = UserWidget.where(user_uuid: session[:current_user][:uuid])
      .where(widgets: @active_widgets)
      .joins(:widget)
      .rank(:row_order)
  end
end
