# frozen_string_literal: true

class WidgetPanel::WidgetPanelComponent < ViewComponent::Base
  def before_render
    permitted_components = params[:components].split(",").map(&:to_sym)
    @active_widgets = Widget.activated_widgets.where(internal: false, component: permitted_components)
    # Ensure that a view component exists for each widget (in case a component is removed or is on another branch)
    @active_widgets = @active_widgets.filter { |w| w.view_component.present? }
    @user_uuid = session[:current_user]&[:uuid]
    @user_widgets = UserWidget.where(user_uuid: @user_uuid)
      .where(widgets: @active_widgets)
      .joins(:widget)
      .rank(:row_order)
  end
end
