# frozen_string_literal: true

class ExampleComponent < ViewComponent::Base
  include Cachable

  def initialize
    @title = "Example Component"
  end

  def before_render
    Rails.cache.fetch("component-#{params[:user_uuid]}", expires_in: default_cache_time, skip_nil: true) do
      json_response = RestClient.get "https://public.gis.lacounty.gov/public/rest/services/LACounty_Dynamic/LMS_Data_Public/MapServer/45/query?where=1%3D1&outFields=*&outSR=4326&f=json"
      @data = JSON.parse(json_response, symbolize_names: true)
    end
  end
end
