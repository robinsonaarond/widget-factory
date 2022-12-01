Rails.application.routes.draw do
  get "welcome/index"

  get "component/:name/:user_uuid" => "component#name", :as => :component_named_default
  get "component/:name/expanded/:user_uuid" => "component#name", :as => :component_named_expanded

  root "welcome#index"
end
