require "sidekiq"
require "sidekiq/web"

redis_conf = YAML.load_file(Rails.root.join("config", "redis.yml"))[Rails.env]
redis_url = ENV.fetch("REDIS_URL") { "redis://#{redis_conf["host"]}:#{redis_conf["port"]}/#{redis_conf["database"]}" }

Sidekiq.strict_args!

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == "wsccoord" && password == "blueprint"
end

Sidekiq.configure_server do |config|
  config.redis = {url: redis_url}
end

Sidekiq.configure_client do |config|
  config.redis = {url: redis_url}
end
