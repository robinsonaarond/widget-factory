require "test_helper"

class Api::UserWidgetsControllerTest < ActionDispatch::IntegrationTest
  include JwtHelper

  def setup
    @user_uuid = "1234"
    @widget = widgets(:one)
    @jwt = get_jwt
  end

  test "should create user widget" do
    assert_difference('UserWidget.count') do
      post api_user_widgets_path, params: { widget_id: @widget.id, row_order_position: 1 }, headers: { "Authorization": @jwt }
    end
    assert_response :created
    response_body = JSON.parse(response.body, symbolize_names: true)
    assert_equal @widget.id, response_body[:widget_id]
    assert_equal @user_uuid, response_body[:user_uuid]
  end

  test "should not create duplicate user widget" do
    user_widget = UserWidget.create(widget_id: @widget.id, user_uuid: @user_uuid, row_order_position: 1)
    assert_no_difference('UserWidget.count') do
      post api_user_widgets_path, params: { widget_id: @widget.id, row_order_position: 2 }, headers: { "Authorization": @jwt }
    end
    assert_response :ok
    response_body = JSON.parse(response.body, symbolize_names: true)
    assert_equal user_widget.id, response_body[:id]
  end

  test "should update user widget" do
    user_widget = UserWidget.create(widget_id: @widget.id, user_uuid: @user_uuid, row_order_position: :last)
    patch api_user_widget_path(@widget.id), params: { row_order_position: :first }, headers: { "Authorization": @jwt }
    assert_response :success
  end

  test "should destroy user widget" do
    user_widget = UserWidget.create(widget_id: @widget.id, user_uuid: @user_uuid, row_order_position: 1)
    assert_difference('UserWidget.count', -1) do
      delete api_user_widget_path(@widget.id), headers: { "Authorization": @jwt }
    end
    assert_response :no_content
  end
end
