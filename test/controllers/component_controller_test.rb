require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should render test component" do
    get component_named_default_path("test", "000000")
    assert_response :success
  end

  test "should render expanded test component" do
    get component_named_expanded_path("test", "000000")
    assert_response :success
  end
end
