Rails.application.routes.draw do
  resources :admins, :passengers, :trains, :tickets, :reviews
  root 'home#index'
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: "passengers#new", as: 'signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  get 'loginAdmin', to: "sessions#newAdmin", as:'loginAdmin'
  get 'viewTrains', to: "passengers#viewTrains", as: 'viewTrains'
  get 'viewTrips', to: "passengers#viewTrips", as: 'viewTrips'
  get 'makeReview/:train_id', to: "reviews#new", as: 'makeReview'
  get 'editReview/:review_id', to: "reviews#edit", as: 'editReview'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
