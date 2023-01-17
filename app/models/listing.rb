class Listing
  def self.return_all_active_listings_for_agent(agent_uuid)
    url = "#{Rails.application.config.listing_service_url}/search/#{agent_uuid}/agent"
    response = RestClient.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.mls_number_search(agent_uuid, mls_numbers)
    url = "#{Rails.application.config.listing_service_url}/search?mls_number=#{mls_numbers}&agent_uuid=#{agent_uuid}"
    response = RestClient.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end
