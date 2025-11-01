json.extract! booking, :id, :user_id, :vehicle_id, :start_date, :end_date, :pickup_address, :dropoff_address, :total_price, :status, :payment_status, :created_at, :updated_at
json.url booking_url(booking, format: :json)
