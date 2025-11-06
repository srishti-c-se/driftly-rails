Rails.application.routes.draw do
  get 'home/index'
  get 'messages/create'
  devise_for :users
  root to: "vehicles#index"

  resources :bookings, only: [:index]
  resources :reviews, only: [:index]

  resources :vehicles do
    resources :bookings do
      # custom member routes for status changes
      member do
        patch :accept   # renter accepts a booking
        patch :reject   # renter rejects a booking
        patch :cancel   # user cancels a booking
      end
      resources :reviews
    end
  end

  root "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
