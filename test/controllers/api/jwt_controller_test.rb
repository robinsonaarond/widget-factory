require "test_helper"

class Api::JwtControllerTest < ActionController::TestCase
  test "should create a JWT token with valid credentials" do
    stub_request(:post, service_url("1234")).to_return(status: 200)
    post :index, params: {uuid: "1234", password: Base64.encode64("password")}
    assert_response :success
    response_body = JSON.parse(@response.body)
    assert_not_nil response_body["token"]
    assert_not_nil response_body["exp"]
  end

  test "should return an error message if the profile service responds with 401" do
    stub_request(:post, service_url("5678")).to_return(status: 401)
    post :index, params: {uuid: "5678", password: Base64.encode64("wrong_password")}
    assert_response :unauthorized
    assert_equal "401 Unauthorized", JSON.parse(@response.body)["message"]
  end

  def service_url(uuid)
    "#{Rails.application.config.service_url[:profile_v2]}/#{uuid}/validate_token"
  end
end
