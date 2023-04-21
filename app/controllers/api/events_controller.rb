class Api::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /api/events
  def create
    widget = Widget.find_by(component: params[:component])
    widget.log_event!(
      params[:event_type],
      params[:event_data],
      session.dig(:current_user, :uuid),
      session.dig(:current_user, :company_uuid),
      session.dig(:current_user, :board_uuid),
      session.dig(:current_user, :office_uuid)
    )
    render json: { success: true }
  end
end
