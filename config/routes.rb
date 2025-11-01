Rails.application.routes.draw do
  resources :reviews
  devise_for :users

  resources :bookings, only: [:index]
  resources :reviews, only: [:index]

  resources :vehicles do
    resources :bookings do
      resources :reviews
    end
  end

  root to: "vehicles#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
