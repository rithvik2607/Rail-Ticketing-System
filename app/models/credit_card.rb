class CreditCard < ApplicationRecord
  belongs_to :passenger

  validates :card_number, presence: true, length: { is: 16 }
  validates :cvv, presence: true, length: { is: 3 }
  validates :expiration_date, presence: true
end
