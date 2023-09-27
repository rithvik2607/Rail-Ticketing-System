json.extract! passenger, :id, :passenger_id, :name, :email, :password, :phoneNumber, :address, :created_at, :updated_at
json.url passenger_url(passenger, format: :json)
