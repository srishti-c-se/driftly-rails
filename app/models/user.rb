class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # VALIDATIONS
  validates :first_name, :last_name, :email, :address, :phone, presence: true
  validates :email, uniqueness: true
  validates :phone, numericality: { only_integer: true }

  # ASSOCIATIONS
  has_many :vehicles, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :messages, dependent: :nullify

  # GEOCODING
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  # Helper methods for roles
  def renter?
    admin == true
  end

  def user?
    admin == false
  end

  def user_type
    admin? ? "renter" : "user"
  end
end
