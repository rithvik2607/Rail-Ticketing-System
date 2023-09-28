class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :password
      t.string :phonenumber
      t.string :address
      t.string :credit_card_number

      t.timestamps
    end
  end
end
