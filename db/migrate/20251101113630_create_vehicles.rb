class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :brand
      t.string :model
      t.integer :year
      t.integer :seats
      t.integer :transmission
      t.integer :fuel_type
      t.decimal :price_per_day
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :active
      t.text :description

      t.timestamps
    end
  end
end
