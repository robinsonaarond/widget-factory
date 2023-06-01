# frozen_string_literal: true

class WidgetPanel::WidgetPanelComponent < ViewComponent::Base
  def before_render
    permitted_components = params[:components].split(",").map(&:to_sym)
    @active_widgets = Widget.activated_widgets.where(component: permitted_components)
    # Ensure that a view component exists for each widget (in case a component is removed or is on another branch)
    @active_widgets = @active_widgets.filter { |w| w.view_component.present? }
    @user_uuid = session.dig(:current_user, :uuid)
    user_removed_widget_ids = UserWidget.where(user_uuid: @user_uuid, removed: true).pluck(:widget_id)
    visible_widget_ids = @active_widgets.pluck(:id) - user_removed_widget_ids
    @widgets = Widget
      .joins("LEFT OUTER JOIN user_widgets ON user_widgets.widget_id = widgets.id AND user_widgets.user_uuid = '#{@user_uuid}'")
      .where(id: visible_widget_ids)
      .order("user_widgets.row_order ASC NULLS LAST")
    log_load_events unless current_page?(component_named_expanded_path)
  end

  def log_load_events
    @widgets.each do |widget|
      Widget.log_event(
        widget.component,
        "widget_dashboard_load",
        {},
        session.dig(:current_user, :uuid),
        session.dig(:current_user, :company_uuid),
        session.dig(:current_user, :board_uuid),
        session.dig(:current_user, :office_uuid)
      )
    end
  end
end
