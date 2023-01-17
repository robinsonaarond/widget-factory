Rails.application.routes.draw do
  get "welcome/index"
  get "welcome/user_session"

  get "component/:name/:session_id" => "component#name", :as => :component_named_default
  get "component/:name/expanded/:session_id" => "component#name", :as => :component_named_expanded

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'listings/:agent_uuid/agent', to: 'listings#agent'
    end
  end

  root "welcome#index"
end
