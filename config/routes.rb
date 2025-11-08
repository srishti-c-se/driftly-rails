Rails.application.routes.draw do
  get 'messages/create'
  devise_for :users
  root to: "pages#home"

  resources :bookings, only: [:index]
  # resources :reviews, only: [:index]

  resources :vehicles do
    resources :bookings do
      resources :reviews, only: [:create, :index]
      resources :messages
      # custom member routes for status changes
      member do
        patch :accept   # renter accepts a booking
        patch :reject   # renter rejects a booking
        patch :cancel   # user cancels a booking
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
