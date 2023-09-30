class Passenger < ApplicationRecord
  has_secure_password
  has_many :tickets, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Please enter a valid email address" }
  validates :phone_number, presence: true, length: { is: 10}
  validates :credit_card_information, presence: true, length: { is: 16}
  
end
