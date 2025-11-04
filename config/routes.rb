Rails.application.routes.draw do
  get 'messages/create'
  resources :reviews
  devise_for :users

  resources :bookings, only: [:index]
  resources :reviews, only: [:index]

  resources :vehicles do
    resources :bookings do
      resources :reviews
    end
  end

  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
