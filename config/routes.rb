Rails.application.routes.draw do
  # Authentication routes
  get "signup", to: "users#new", as: :signup
  post "users", to: "users#create"
  resource :session
  resources :passwords, param: :token

  # User profile — legacy paths, kept as redirects to the settings hub
  get "profile",         to: redirect("/configuracion/account",      status: 301), as: :profile
  get "profile/edit",    to: redirect("/configuracion/account/edit", status: 301)
  patch "profile",       to: redirect("/configuracion/account",      status: 308)
  patch "profile/language",    to: redirect("/configuracion/preferences", status: 308)
  patch "profile/preferences", to: redirect("/configuracion/preferences", status: 308)

  # Main resources
  resources :clients
  resources :suppliers
  resources :products

  # Organizations
  resources :organizations do
    resources :invitations, only: [ :new, :create ]
  end

  # Invitation acceptance
  get "invitations/accept/:token", to: "invitations#accept", as: :accept_invitation

  # Legacy paths — redirect into the settings hub
  get "/admin/users",                              to: redirect("/configuracion/team_members", status: 301)
  get "/configuracion-fiscal",                     to: redirect("/configuracion/fiscal", status: 301)
  get "/configuracion-fiscal/establishments",     to: redirect("/configuracion/fiscal", status: 301)
  get "/configuracion-fiscal/cai_authorizations", to: redirect("/configuracion/fiscal", status: 301)

  # Settings hub — unifies account, preferences, organization, team, and SAR fiscal config
  namespace :settings, path: "configuracion" do
    root to: "home#index"
    resource :account,      only: [ :show, :edit, :update ], controller: "accounts"
    resource :preferences,  only: [ :show, :update ],         controller: "preferences"
    resource :organization, only: [ :show, :edit, :update ],  controller: "organization"
    resources :team_members, only: [ :index, :edit, :update ]
    get "fiscal", to: "fiscal#show", as: :fiscal
    resources :establishments do
      resources :emission_points, except: [ :index ]
    end
    resources :cai_authorizations
  end

  # SAR credit / debit notes (linked to original invoice)
  resources :credit_notes, only: [ :new, :create, :show ]
  resources :debit_notes, only: [ :new, :create, :show ]

  # Invoices and invoice items
  resources :invoices do
    resources :invoice_items, shallow: true
    collection do
      get :add_item
    end
    member do
      get :pdf
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
