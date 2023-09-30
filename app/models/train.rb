class Train < ApplicationRecord
  has_many :tickets, dependent: :destroy
  has_many :reviews, dependent: :destroy
  
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
  validates :departure_station, :termination_station, presence: true
  validates :ticket_price, numericality: { greater_than: 0, message: "must be a positive value" }
  validate :validate_time_format
  validate :departure_date_must_be_before_arrival_date
  validate :stations_must_be_different
  validate :number_of_seats

  
  def validate_time_format
    unless departure_time.is_a?(Time) && arrival_time.is_a?(Time)
      errors.add(:departure_time, 'must be a valid time')
      errors.add(:arrival_time, 'must be a valid time')
    end
  end

  def departure_date_must_be_before_arrival_date
    if departure_date && arrival_date && departure_date >= arrival_date
      errors.add(:departure_date, "must be before the arrival date")
    end
  end

  def stations_must_be_different
    if departure_station == termination_station
      errors.add(:base, "Departure station and termination station cannot be the same")
    end
  end

  def number_of_seats
    if train_capacity && number_of_seats_left && train_capacity < number_of_seats_left
      errors.add(:train_capacity, "must be greater than the number of seats left")
    end
  end
end
