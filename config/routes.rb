Rails.application.routes.draw do
  root "home#index"

  resources :recipes do
    resources :recipe_ingredients, only: [ :create, :destroy ]

    # XLSX export/import
    member do
      get :export_xlsx, to: "recipe_xlsx#export"
      post :import_xlsx, to: "recipe_xlsx#import"
    end
  end

  resources :ingredients do
    # XLSX export/import for ingredients
    collection do
      get :export_xlsx, to: "ingredients_xlsx#export"
      post :import_xlsx, to: "ingredients_xlsx#import"
    end
  end
  resources :products do
    # XLSX export/import for products
    collection do
      get :export_xlsx, to: "products_xlsx#export"
      post :import_xlsx, to: "products_xlsx#import"
    end
  end
  resources :market_simulations, only: [ :index, :show, :new, :create ] do
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
