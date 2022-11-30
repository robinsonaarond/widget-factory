Rails.application.routes.draw do
  get "welcome/index"

  get "component/:name" => "component#name", :as => :component_default

  root "welcome#index"
end
