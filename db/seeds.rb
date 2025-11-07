require 'faker'

puts 'Cleaning database...'
Review.destroy_all
Booking.destroy_all
Vehicle.destroy_all
User.destroy_all

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
vehicles = []

20.times do
  vehicles << Vehicle.create!(
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

puts '🌱 Seeding bookings...'
bookings = []

vehicles.each do |vehicle|
  rand(1..3).times do
    bookings << Booking.create!(
      user: users.sample,
      vehicle: vehicle,
      start_date: Faker::Date.backward(days: 30),
      end_date: Faker::Date.forward(days: 30)
    )
  end
end

puts '🌱 Seeding reviews...'
bookings.each do |booking|
  if [true, false].sample
    Review.create!(
      user: booking.user,
      booking: booking,
      vehicle: booking.vehicle,
      rating: rand(1..5),
      comment: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end
end

puts '✅ Done seeding everything!'
