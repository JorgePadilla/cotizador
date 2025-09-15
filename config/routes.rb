Rails.application.routes.draw do
  # Authentication routes
  get "signup", to: "users#new", as: :signup
  post "users", to: "users#create"
  resource :session
  resources :passwords, param: :token

  # User profile
  get "profile", to: "profiles#show"
  get "profile/edit", to: "profiles#edit"
  patch "profile", to: "profiles#update"
  patch "profile/language", to: "profiles#update_language"
  patch "profile/preferences", to: "profiles#update_preferences"

  # Main resources
  resources :clients
  resources :suppliers
  resources :products
  
  # Organizations
  resources :organizations do
    resources :invitations, only: [:new, :create]
  end
  
  # Invitation acceptance
  get "invitations/accept/:token", to: "invitations#accept", as: :accept_invitation
  
  # Admin interface
  namespace :admin do
    resources :users, only: [:index, :edit, :update]
  end

  # Invoices and invoice items
  resources :invoices do
    resources :invoice_items, shallow: true
    collection do
      get :add_item
    end
  end

  # Quotes and quote items
  resources :quotes do
    resources :quote_items, shallow: true
    member do
      get :pdf
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
