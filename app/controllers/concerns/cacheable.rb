module Cacheable
  extend ActiveSupport::Concern
  def default_cache_time
    self.class.default_cache_time
  end

  class_methods do
    def default_cache_time
      Rails.env.development? ? 1.minute : 1.hour
    end
  end
end
