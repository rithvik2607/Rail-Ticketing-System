Rails.application.routes.draw do

  resources :admins, :passengers, :tickets, :reviews
  resources :trains do
    collection do
      get :filter_trains
    end
  end


  root 'home#index'
  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: "passengers#new", as: 'signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  # get 'loginAdmin', to: "sessions#newAdmin", as:'loginAdmin'
  get 'viewTrains', to: "passengers#viewTrains", as: 'viewTrains'
  get 'viewTrips', to: "passengers#viewTrips", as: 'viewTrips'
  get 'makeReview/:train_id', to: "reviews#new", as: 'makeReview'
  get 'editReview/:review_id', to: "reviews#edit", as: 'editReview'
  get 'filter_trains', to: "trains#filter_trains", as: 'filter_trains'
  get 'filter_reviews', to: "reviews#filter_reviews", as: 'filter_reviews'
  # get 'filtered_trains', to: "trains#filtered_trains", as: 'filtered_trains'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
