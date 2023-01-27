class Api::UserWidgetsController < ApplicationController
  before_action :set_user_widget, only: [:update, :destroy]
  skip_before_action :verify_authenticity_token

  # POST /api/user_widgets
  def create
    @user_widget = UserWidget.new(user_widget_params)
    @user_widget.user_uuid = session[:current_user][:uuid]

    if @user_widget.save
      render json: @user_widget, status: :created
    else
      render json: @user_widget.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/user_widgets/1
  def update
    if @user_widget.update(user_widget_params)
      render json: @user_widget
    else
      render json: @user_widget.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/user_widgets/1
  def destroy
    @user_widget.destroy
  end

  private

  def set_user_widget
    user_uuid = session[:current_user][:uuid]
    @user_widget = UserWidget.find_by(widget_id: params[:id], user_uuid: user_uuid)
  end

  def user_widget_params
    params.permit(:widget_id, :row_order_position)
  end
end
