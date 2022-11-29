class ComponentController < ApplicationController
  def name
    render(
      Object::const_get("#{params[:name]}Component".camelize).new()
    ) 
  end
end
