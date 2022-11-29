class ComponentController < ApplicationController
  def name
    render(
      Object::const_get("#{params[:name].camelize}Component").new()
    ) 
  end
end
