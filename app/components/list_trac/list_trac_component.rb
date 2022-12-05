# frozen_string_literal: true

class ListTrac::ListTracComponent < ViewComponent::Base
  # rubocop:disable Metrics/MethodLength
  def before_render
    @token = token
    # @data = RestClient.post(
    #   'https://b2b.listtrac.com/api/GetMetricsByOrganization',
    #   {
    #     "token": token,
    #     "viewtype": 'mls',
    #     "viewtypeID": 'stellar',
    #     "metric": 'view,inquiry',
    #     "details": 'true',
    #     "startdate": '20220909',
    #     "enddate": '20221123'
    #   }
    # )
    @listings = demo_listings # TODO: only use demo listings for widget library demo
  end
  # rubocop:enable Metrics/MethodLength

  def token
    pass = VendorApiAccess["list_trac"]["password"]
    key_params = {
      orgID: "stellar",
      username: VendorApiAccess["list_trac"]["username"]
    }
    json_response = RestClient.get "https://b2b.listtrac.com/api/getkey?#{key_params.to_query}"
    response = JSON.parse(json_response, symbolize_names: true)
    Digest::MD5.hexdigest(pass + response[:key])
  end

  def demo_listings
    [
      {
        address: "123 Main St",
        views: 100,
        leads: 10
      },
      {
        address: "456 Main St",
        views: 200,
        leads: 20
      },
      {
        address: "789 Main St",
        views: 300,
        leads: 30
      },
      {
        address: "101 Main St",
        views: 400,
        leads: 40
      }
    ]
  end
end
