json.extract! credit_card, :id, :name, :card_number, :expiration_date, :cvv, :created_at, :updated_at
json.url credit_card_url(credit_card, format: :json)
