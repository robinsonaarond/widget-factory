ENV["RAILS_ENV"] ||= "test"
require "webmock/minitest"
require_relative "../config/environment"
require "rails/test_help"

require 'knapsack'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  setup do
    WebMock.allow_net_connect!
  end  
end

knapsack_adapter = Knapsack::Adapters::MinitestAdapter.bind
knapsack_adapter.set_test_helper_path(__FILE__)

module JwtHelper
  def get_jwt
    # Stub authentication request
    stub_request(:post, "#{Rails.application.config.service_url[:profile_v2]}/1234/validate_token").to_return(status: 200)
    # Stub future requests to get user profile
    stub_request(:get, "#{Rails.application.config.service_url[:profile_v3]}/nucleus/profile/1234")
      .with(query: hash_including({}))
      .to_return(status: 200, body: {data: [{uuid: "1234", office: {}, company: {}, board: {}}]}.to_json)
    post api_jwt_path, params: {uuid: "1234", password: Base64.encode64("password")}
    JSON.parse(@response.body)["token"]
  end
end
