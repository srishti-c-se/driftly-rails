class Review < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle
  belongs_to :booking
end
