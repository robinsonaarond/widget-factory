class ComponentController < ApplicationController
  include Cachable

  before_action :put_time
  caches_action :name, expires_in: default_cache_time

  def name
    # Looks for namespaced component first.
    obj = begin
      Object.const_get("#{params[:name].camelize}::#{params[:name].camelize}Component").new
    rescue
      Object.const_get("#{params[:name].camelize}Component").new
    end

    render(obj)
  end

  private

  # Temporary method to make sure action caching
  # is working properly. This will be swapped out
  # for session verification.
  def put_time
    p "+_+_+_+_+_+"
    p Time.now
  end
end
