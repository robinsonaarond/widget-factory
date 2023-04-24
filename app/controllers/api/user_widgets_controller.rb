class Api::UserWidgetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # PATCH /api/user_widgets
  def update_order
    user_uuid = session[:current_user][:uuid]
    params[:widget_ids].each_with_index do |widget_id, index|
      user_widget = UserWidget.find_or_initialize_by(widget_id: widget_id, user_uuid: user_uuid)
      user_widget.row_order_position = index + 1
      user_widget.save
    end
    render json: { status: :ok }
  end

  # DELETE /api/user_widgets/:id
  def destroy
    user_uuid = session[:current_user][:uuid]
    user_widget = UserWidget.find_or_initialize_by(widget_id: params[:id], user_uuid: user_uuid)
    user_widget.removed = true
    if user_widget.save
      render json: { status: :ok }
    else
      render json: { status: :error }
    end
  end

  # POST /api/user_widgets/:id/restore
  def restore
    user_uuid = session[:current_user][:uuid]
    user_widget = UserWidget.find_or_initialize_by(widget_id: params[:id] || params[:widget_id], user_uuid: user_uuid)
    user_widget.removed = false
    if user_widget.save
      render json: { status: :ok }
    else
      render json: { status: :error }
    end
  end
end
