json.extract! vehicle, :id, :user_id, :title, :brand, :model, :year, :seats, :transmission, :fuel_type, :price_per_day, :address, :latitude, :longitude, :active, :description, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
