Rails.application.routes.draw do
  get "welcome/index"

  get "component/:name" => "component#name", :as => :component_default
  get "component/:name/expanded" => "component#name", :as => :component_expanded

  root "welcome#index"
end
