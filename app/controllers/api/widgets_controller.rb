class Api::WidgetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /api/widgets
  def index
    @widgets = Widget.where(internal: false)
    render json: @widgets
  end

  # GET /api/widgets/1
  def show
    @widget = Widget.find(params[:id])
    render json: @widget
  end

  # PATCH/PUT /api/widgets/1
  def update
    @widget = Widget.find(params[:id])
    if @widget.update(widget_params)
      render json: @widget
    else
      render json: @widget.errors, status: :unprocessable_entity
    end
  end

  private

  def widget_params
    params.require(:widget).permit(:name, :description, :status, :activation_date)
  end
end
