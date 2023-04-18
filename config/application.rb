require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WidgetFactory
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "ALLOWALL", # Allow iframes
      "X-XSS-Protection" => "1; mode=block", # Rails Default
      "X-Content-Type-Options" => "nosniff" # Rails Default
    }
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.memcached_server = "memcached-nucleus-1-devint.xq42gy.cfg.usw2.cache.amazonaws.com:11211"
    config.cache_store = :mem_cache_store, config.memcached_server, {namespace: "_widgetfactory_"}
    config.action_controller.perform_caching = true
    config.action_controller.page_cache_directory = Rails.root.join("public", "cached_pages")

    config.before_initialize do
      config.service_url = {
        auth: ENV["auth_service_url"] || "#{config.base_service}/service/v1/auth",
        profile_v2: ENV["profile_service_v2_url"] || "#{config.base_service}/service/profile/v2",
        profile_v3: ENV["profile_service_v2_url"] || "#{config.base_service}/service/profile/v3",
      }

      config.active_job.queue_adapter = :sidekiq
    end
  end
end
