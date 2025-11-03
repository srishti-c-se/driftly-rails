class Review < ApplicationRecord
  # VALIDATIONS
  validates :rating, numericality: { only_integer: true, in: 0..5 }

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :vehicle
  belongs_to :booking
end
