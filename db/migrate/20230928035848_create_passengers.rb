class CreatePassengers < ActiveRecord::Migration[7.0]
  def change
    create_table :passengers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone_number
      t.string :address
      t.string :credit_card_information

      t.timestamps
    end
  end
end
