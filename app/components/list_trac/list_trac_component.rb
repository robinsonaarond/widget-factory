# frozen_string_literal: true

class ListTrac::ListTracComponent < ViewComponent::Base
  def initialize(library_mode: false)
    @library_mode = library_mode
  end

  def before_render
    @library_mode ||= params[:library_mode]
    @listings = []
    @error = nil
    @error_with_api = false
    begin
      @widget = Widget.find_by(component: "list_trac")
      @token = token unless @library_mode
      @listings = @library_mode ? demo_listings : agent_listings
      @listings = @listings.sort_by { |listing| listing[:ViewCount] }.reverse
    rescue => e
      @error = e.message
      @error_with_api = e.is_a?(RestClient::Exception) || e.is_a?(SocketError)
    end
  end

  def agent_listings
    params = {
      access_token: token,
      TrackingType: "Agent",
      TrackingValues: session[:current_user][:mls_number],
      # TrackingValues: "364512302",
      ResponseType: "summary"
    }
    begin
      response = RestClient::Request.execute(
        method: :get,
        timeout: 10,
        url: "https://b2b.listtrac.com/RESO/OData/InternetTracking?#{params.to_query}",
        verify_ssl: false
      )
      json = JSON.parse(response, symbolize_names: true)
      [json[:value] || [], (json[:status] == "ok") ? nil : json[:description]]
    rescue RestClient::ExceptionWithResponse => e
      message = e.message || "Unknown error getting listings from ListTrac API"
      @widget.log_event!(
        'widget_error',
        {message: message, endpoint: endpoint, payload: payload},
        session.dig(:current_user, :uuid),
        session.dig(:current_user, :company_uuid),
        session.dig(:current_user, :board_uuid),
        session.dig(:current_user, :office_uuid)  
      )
      [{}, message]
    end
  end

  def token
    pass = VendorApiAccess["list_trac"]["password"]
    key_params = {
      orgID: "stellar",
      username: VendorApiAccess["list_trac"]["username"]
    }
    json_response = RestClient::Request.execute(
      method: :get,
      url: "https://b2b.listtrac.com/api/getkey?#{key_params.to_query}",
      verify_ssl: false
    )
    response = JSON.parse(json_response, symbolize_names: true)
    Digest::MD5.hexdigest(pass + response[:key])
  end

  def demo_listings
    [
      {
        Address: "123 Main St",
        ViewCount: 100,
        InquiryCount: 10
      },
      {
        Address: "456 Main St",
        ViewCount: 200,
        InquiryCount: 20
      },
      {
        Address: "789 Main St",
        ViewCount: 300,
        InquiryCount: 30
      },
      {
        Address: "101 Main St",
        ViewCount: 400,
        InquiryCount: 40
      }
    ]
  end
end
