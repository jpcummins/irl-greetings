Rails.application.routes.draw do
  resources :users do
    member do
      get :auth
      post :is_authorized
      get :print
      get :admin
      get :stats
    end
  end

  root 'public#index'

  get "/logout" => 'public#logout'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
