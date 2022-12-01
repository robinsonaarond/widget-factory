class ComponentController < ApplicationController
  before_action :put_time
  caches_action :name

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

  def put_time
    p "+_+_+_+_+_+"
    p Time.now
  end
end
