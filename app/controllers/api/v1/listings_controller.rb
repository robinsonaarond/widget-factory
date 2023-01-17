class Api::V1::ListingsController < ApplicationController
  def agent
    url = "#{Rails.application.config.listing_service_url}/search/#{params[:agent_uuid]}/agent"
    response = RestClient.get(url)
    render json: response.body
  end
end
