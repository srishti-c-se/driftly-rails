class Booking < ApplicationRecord
  # VALIDATIONS
  validates :start_date, :end_date, presence: true
  validate  :end_after_start
  before_validation :calculate_total_price, if: -> { start_date.present? && end_date.present? }

  # ASSOCIATIONS
  belongs_to :user
  belongs_to :vehicle
  has_many   :messages, as: :threadable, dependent: :destroy
  has_one :review, dependent: :destroy # The review belongs to that one booking.

  # ASSIGNMENTS
  enum status: {
    pending: 0,
    accepted: 1,
    rejected: 2,
    cancelled: 3,
    completed: 4
  }

  enum payment_status: {
    unpaid: 0,
    paid: 1,
    refunded: 2
  }

  def end_after_start
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  def calculate_total_price
    if vehicle && vehicle.price_per_day
      days = (end_date - start_date).to_i
      days = 1 if days < 1
      self.total_price = (vehicle.price_per_day * days).round(2)
    end
  end
end
