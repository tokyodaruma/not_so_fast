Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'pages#home'

  resources :sites
  resources :notifications, only: %i[index show update create] do
    resources :sites
  end

  resources :care_receivers, only: %i[create]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sites, :notifications, only: %i[index update create]
      post 'sites/risk-check', to: 'sites#call'
    end
  end

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
