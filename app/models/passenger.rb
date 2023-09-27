class Passenger < ApplicationRecord
  has_secure_password
  has_many :credit_cards
  validates :passenger_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :phoneNumber, presence: true
  validates :address, presence: true
end
