Rails.application.routes.draw do
  root to: "home#index"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :volunteers
  resources :institutions
  resources :formations, only: %i[index] do
    get :show_by_year, on: :collection
  end
  resources :teams

  resources :imports, only: %i[index] do
    collection do
      resources :import_formations, controller: "imports/import_formations", only: %i[show new create]
      resources :import_children, controller: "imports/import_children", only: %i[show new create]
      resources :import_volunteers, controller: "imports/import_volunteers", only: %i[show new create]
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
