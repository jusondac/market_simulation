Rails.application.routes.draw do
  get "ingredient_types/index"
  get "ingredient_types/new"
  get "ingredient_types/create"
  get "ingredient_types/edit"
  get "ingredient_types/update"
  get "ingredient_types/destroy"
  get "units/index"
  get "units/new"
  get "units/create"
  get "units/edit"
  get "units/update"
  get "units/destroy"
  get "settings/index"
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
      get :unit_converter
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

  # Settings routes
  resources :settings, only: [:index] do
    collection do
      resources :units, except: [:show]
      resources :ingredient_types, except: [:show]
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
