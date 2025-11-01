class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :pickup_address
      t.string :dropoff_address
      t.decimal :total_price
      t.integer :status
      t.integer :payment_status

      t.timestamps
    end
  end
end
