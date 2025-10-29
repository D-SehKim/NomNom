Rails.application.routes.draw do
  resources :grocery_items do
    member do
      patch :toggle_purchased
    end
  end
  resources :items, only: [:index, :new, :create, :destroy]
  get "recipes", to: "recipes#index"
  get "recipes/:id", to: "recipes#show", as: "recipe"
  devise_for :users

  resources :user_meals, only: [:index, :new, :create, :destroy] do
    collection do
      delete :clear_all
    end

    # delete :clear_all, on: :collection
    resources :user_meal_ingredients, only: [:destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "home#index"
end
