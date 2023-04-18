class Resource::Auth < WmsResource::Resource
  self.site = Rails.application.config.service_url[:auth]

  def self.poll(session_id)
    Rails.cache.fetch(session_id, expires_in: 5.minutes, skip_nil: true) do
      raw = get("/users/poll", query: {session_id: session_id}, authed_action: "poll", wms_response: false)
      if raw[0]["success"] && raw[0]["valid"]
        raw[0]["token"]
      end
    end
  end
end
