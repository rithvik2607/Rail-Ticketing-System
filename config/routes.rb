Rails.application.routes.draw do
  resources :reviews
  resources :admins, :passengers, :trains, :tickets
  root 'home#index'
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: "passengers#new", as: 'signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  get 'loginAdmin', to: "sessions#newAdmin", as:'loginAdmin'
  get 'viewTrains', to: "passengers#viewTrains", as: 'viewTrains'
  get 'viewTrips', to: "tickets#viewTrips", as: 'viewTrips'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
