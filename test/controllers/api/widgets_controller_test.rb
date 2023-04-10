require "test_helper"

class Api::WidgetsControllerTest < ActionController::TestCase
  test "should get widgets" do
    get :index
    assert_response :success
    response_body = JSON.parse(response.body)
    assert_equal 2, response_body.length
  end

  test "should get single widget" do
    widget = widgets(:one)
    get :show, params: { id: widget.id }
    assert_response :success
    response_body = JSON.parse(response.body)
    assert_equal widget.id, response_body["id"]
  end

  test "should update widget" do
    widget = widgets(:one)
    new_properties = {
      name: "New Widget Name",
      description: "New Widget Description",
      status: "ready",
      activation_date: "2023-04-07T00:00:00.000Z",
      updated_by: "John Doe",
      logo_base64: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
    }
    put :update, params: {
      id: widget.id,
      widget: new_properties
    }
    assert_response :success
    response_body = JSON.parse(response.body)
    assert_equal new_properties[:name], response_body["name"]
    assert_equal new_properties[:description], response_body["description"]
    assert_equal new_properties[:status], response_body["status"]
    assert_equal new_properties[:activation_date], response_body["activation_date"]
    assert_equal new_properties[:updated_by], response_body["updated_by"]
    assert_not_nil response_body["logo_url"]
  end
end
