# frozen_string_literal: true

class Hurdlr::HurdlrComponent < ViewComponent::Base
  def before_render
    @data = demo_data
    # @data = user_vitals
  end

  def user_vitals
    api_post("userVitals", { userId: VendorApiAccess["hurdlr"]["test_user_id"] })
  end

  def api_post(endpoint, payload)
    base_url = Rails.env.development? ? "https://sandbox.hurdlr.com/rest/v1/enterprise" : "https://app.hurdlr.com/rest/v1/enterprise"
    token = VendorApiAccess["hurdlr"][Rails.env.development? ? "sandbox_token" : "production_token"]
    json = RestClient.post("#{base_url}/#{endpoint}", payload.to_json, headers={Authorization: "Bearer #{token}"})
    JSON.parse(json, symbolize_names: true)
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
