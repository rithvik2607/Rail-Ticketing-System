json.extract! admin, :id, :username, :name, :email, :password, :phonenumber, :address, :credit_card_number, :created_at, :updated_at
json.url admin_url(admin, format: :json)
