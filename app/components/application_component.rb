class ApplicationComponent < ViewComponent::Base
  def initialize(widget: nil, library_mode: false)
    @library_mode = library_mode
    @widget = widget # Set only when widget is rendered inside the widget panel
  end

  def before_render
    @library_mode ||= params[:library_mode]
    @error = nil
    @error_with_api = false
    begin
      component_name = params[:name] || self.class.to_s.underscore.split("/").first
      @widget ||= Widget.find_by(component: component_name)
    rescue => e
      @error = e.message
      log_error(e)
    end
  end

  def log_error(e)
    Widget.log_event(
      @widget.component,
      "widget_error",
      {message: e.message, endpoint: request.env[:REQUEST_URI]},
      session.dig(:current_user, :uuid),
      session.dig(:current_user, :company_uuid),
      session.dig(:current_user, :board_uuid),
      session.dig(:current_user, :office_uuid)  
    ) rescue nil
  end
end
