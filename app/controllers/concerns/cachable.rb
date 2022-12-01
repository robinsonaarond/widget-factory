module Cachable
  extend ActiveSupport::Concern
  def default_cache_time
    Rails.env.development? ? 1.minute : 1.hour
  end
end
