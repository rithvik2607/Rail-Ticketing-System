json.extract! passenger, :id, :name, :email, :password_digest, :phone_number, :address, :credit_card_information, :created_at, :updated_at
json.url passenger_url(passenger, format: :json)
