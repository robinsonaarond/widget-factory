require "test_helper"

class Api::UserWidgetsControllerTest < ActionDispatch::IntegrationTest
  include JwtHelper

  def setup
    @user_uuid = "1234"
    @widget_ids = [widgets(:one).id, widgets(:two).id, widgets(:three).id]
    @jwt = get_jwt
  end

  test "should set widget order" do
    patch api_user_widgets_path, params: {widget_ids: @widget_ids}, headers: {Authorization: @jwt}
    assert_response :success
    assert_equal @widget_ids, UserWidget.where(user_uuid: @user_uuid).pluck(:widget_id)
    patch api_user_widgets_path, params: {widget_ids: @widget_ids.reverse}, headers: {Authorization: @jwt}
    assert_response :success
    assert_equal @widget_ids.reverse, UserWidget.where(user_uuid: @user_uuid).pluck(:widget_id)
  end

  test "should remove user widget" do
    delete api_destroy_user_widget_path(widgets(:one).id), headers: {Authorization: @jwt}
    assert_response :success
    assert user_widgets(:one).removed
  end

  test "should remove widget that was not previously removed/ordered" do
    assert_difference "UserWidget.count", 1 do
      delete api_destroy_user_widget_path(widgets(:three).id), headers: {Authorization: @jwt}
    end
  end

  test "should restore user widget" do
    post api_restore_user_widget_path(widgets(:two).id), headers: {Authorization: @jwt}
    assert_response :success
    refute user_widgets(:two).removed
  end
end
