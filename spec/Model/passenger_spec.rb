require 'rails_helper'

RSpec.describe Passenger, type: :model do
  it "should be valid with valid attributes" do
    passenger = Passenger.new(
      email: "test@example.com",
      phone_number: "1234567890",
      credit_card_information: "1234567890123456",
      password: "password"
    )
    expect(passenger).to be_valid
  end

  it "should not be valid without an email" do
    passenger = Passenger.new(
      phone_number: "1234567890",
      credit_card_information: "1234567890123456",
      password: "password"
    )
    expect(passenger).not_to be_valid
  end

 
end