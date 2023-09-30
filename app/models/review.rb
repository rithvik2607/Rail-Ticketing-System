class Review < ApplicationRecord
  belongs_to :passenger
  belongs_to :train

  validates :rating, presence: true, inclusion: { in: 1..5, message: "Rating must be within 1 to 5" }
  validates :feedback, presence: true
end
