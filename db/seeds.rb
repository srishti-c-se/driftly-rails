# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
require 'faker'

puts '🌱 Seeding users...'
users = []

5.times do
  users << User.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    email:      Faker::Internet.unique.email,
    phone:      Faker::Number.number(digits: 8),
    address:    Faker::Address.full_address,     
    password:   "password"
  )
end

puts '🌱 Seeding vehicles...'

20.times do
  vehicle = Vehicle.create!(
    title: Faker::Vehicle.make_and_model,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price_per_day: rand(1000..3000),
    transmission: Vehicle.transmissions.keys.sample,
    year: Faker::Vehicle.year,
    seats: Faker::Number.between(from: 2, to: 5),
    fuel_type: Vehicle.fuel_types.keys.sample,
    address: Faker::Address.full_address,
    user: users.sample
  )
end

puts '✅ Done seeding!'
