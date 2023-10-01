require 'rails_helper'

RSpec.describe PassengersController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new passenger' do
        passenger_params = {
          email: 'test@example.com',
          phone_number: '1234567890',
          credit_card_information: '1234567890123456',
          password: 'password'
        }

        expect {
          post :create, params: { passenger: passenger_params }
        }.to change(Passenger, :count).by(1)

        expect(response).to redirect_to(passenger_path(Passenger.last))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new passenger' do
        passenger_params = {
          phone_number: '1234567890',
          credit_card_information: '1234567890123456',
          password: 'password'
        }

        expect {
          post :create, params: { passenger: passenger_params }
        }.not_to change(Passenger, :count)

        expect(response).to render_template(:new)
      end
    end
  end


end