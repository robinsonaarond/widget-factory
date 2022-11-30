class ComponentController < ApplicationController
  def name
    # Looks for namespaced component first.
    obj = begin
      Object.const_get("#{params[:name].camelize}::#{params[:name].camelize}Component").new
    rescue
      Object.const_get("#{params[:name].camelize}Component").new
    end

    render(obj)
  end
end
