Rails.application.routes.draw do
  resources :users do
    member do
      get :auth
      post :is_authorized
    end
  end

  root 'public#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
