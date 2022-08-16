Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :sites
  resources :notifications, only: %i[index show] do
    resources :sites

  get '/page/:page', action: :index, on: :collection
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sites, :notifications, only: %i[index update create]
      post 'sites/risk-check', to: 'sites#call'
    end
  end
end
