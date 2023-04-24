# frozen_string_literal: true

class WidgetPanel::WidgetPanelComponent < ViewComponent::Base
  def before_render
    permitted_components = params[:components].split(",").map(&:to_sym)
    @active_widgets = Widget.activated_widgets.where(internal: false, component: permitted_components)
    # Ensure that a view component exists for each widget (in case a component is removed or is on another branch)
    @active_widgets = @active_widgets.filter { |w| w.view_component.present? }
    @user_uuid = session.dig(:current_user, :uuid)
    user_removed_widget_ids = UserWidget.where(user_uuid: @user_uuid, removed: true).pluck(:widget_id)
    user_restored_widget_ids = UserWidget.where(user_uuid: @user_uuid, removed: false).pluck(:widget_id)
    @widgets = Widget
      .joins("LEFT OUTER JOIN user_widgets ON user_widgets.widget_id = widgets.id AND user_widgets.user_uuid = '#{@user_uuid}'")
      .where(id: @active_widgets.pluck(:id))
      .where.not(id: user_removed_widget_ids)
      .or(Widget.where(id: user_restored_widget_ids))
      .order('user_widgets.row_order ASC NULLS LAST')
  end
end
