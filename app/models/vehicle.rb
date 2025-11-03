class Vehicle < ApplicationRecord
  # VALIDATIONS
  validates :title, :address, presence: true
  validates :price_per_day, numericality: { greater_than: 0 }, allow_nil: true
  validates :seats, numericality: { greater_than: 0 }, allow_nil: true
  enum :transmission, { manual: 0, automatic: 1 }, prefix: true
  enum :fuel_type,    { petrol: 0, diesel: 1, hybrid: 2, electric: 3 }, prefix: true

  # ASSOCIATIONS
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews,  dependent: :destroy
end
