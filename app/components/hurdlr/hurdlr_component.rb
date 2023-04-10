# frozen_string_literal: true

class Hurdlr::HurdlrComponent < ViewComponent::Base
  def initialize(library_mode: false)
    @library_mode = library_mode
  end

  def before_render
    @library_mode ||= params[:library_mode]
    @data = {}
    @error = nil
    @error_with_api = false
    begin
      @widget = Widget.find_by(component: "hurdlr")
      @data, @error = @library_mode ? [demo_data, nil] : user_vitals
      @error_with_api = @error.present?
    rescue => e
      @error = e.message
    end
  end

  def user_vitals
    api_post("userVitals", {userId: session[:current_user][:mls_number]})
    # api_post("userVitals", {userId: VendorApiAccess["hurdlr"]["test_user_id"]})
  end

  def api_post(endpoint, payload)
    base_url = (Rails.env.production? || Rails.env.uat?) ? "https://app.hurdlr.com/rest/v1/enterprise" : "https://sandbox.hurdlr.com/rest/v1/enterprise"
    token = VendorApiAccess["hurdlr"]["token"]
    begin
      response = RestClient::Request.execute(
        method: :post,
        timeout: 10,
        url: "#{base_url}/#{endpoint}",
        payload: payload.to_json,
        headers: {Authorization: "Bearer #{token}"}
      )
      data = JSON.parse(response, symbolize_names: true)
      [data, data[:errorMessage]]
    rescue RestClient::ExceptionWithResponse => e
      [{}, e.message || "Unknown error getting Hurdlr data"]
    end
  end

  def demo_data
    {
      currencyType: "USD",
      revenue: 43794, # Income
      expenses: 5730, # Expenses
      overallTaxAmount: 6101, # Taxes
      afterTaxIncome: 31961, # Profit after tax
      ytdTaxSavings: 1234, # “YTD Tax Savings” or “Current Tax Savings”
      projectedTaxSavings: 1234 # Estimated Annual Savings
    }
  end
end
