require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get example component" do
    # Tests that the example component is rendered.
    get component_named_default_path("example", "000000")
    assert_response :success
  end

  test "should get extended example component" do
    # Tests that the example component is rendered.
    get component_named_expanded_path("example", "000000")
    assert_response :success
  end
end
