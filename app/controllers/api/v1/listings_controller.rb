class Api::V1::ListingsController < ApplicationController
  def agent
    url = "#{Rails.application.config.listing_service_url}/search/#{params[:agent_uuid]}/agent"
    response = RestClient.get(url)
    render json: response.body
  end

  def mls_number_search
    url = "#{Rails.application.config.listing_service_url}/search?mls_number=#{params[:mls_number]}&agent_uuid=#{params[:agent_uuid]}"
    response = RestClient.get(url)
    render json: response.body
  end
end
