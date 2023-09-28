Rails.application.routes.draw do
  resources :tickets
  resources :passengers
  root 'home#index'
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: "passengers#new", as: 'signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
