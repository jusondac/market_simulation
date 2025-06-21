Rails.application.routes.draw do
  root "home#index"
  
  resources :recipes do
    resources :recipe_ingredients, only: [:create, :destroy]
  end
  
  resources :ingredients
  resources :products
  resources :market_simulations, only: [:index, :show, :new, :create] do
    member do
      post :simulate
    end
  end
  
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
  
  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
