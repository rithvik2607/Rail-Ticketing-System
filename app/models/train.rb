class Train < ApplicationRecord
  has_many :tickets
  has_many :reviews
  
  validates :departure_time, presence: true
  validates :arrival_time, presence: true
  validate :validate_time_format

  def validate_time_format
    unless departure_time.is_a?(Time) && arrival_time.is_a?(Time)
      errors.add(:departure_time, 'must be a valid time')
      errors.add(:arrival_time, 'must be a valid time')
    end
  end
end
