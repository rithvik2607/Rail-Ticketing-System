class CreatePassengers < ActiveRecord::Migration[7.0]
  def change
    create_table :passengers do |t|
      t.string :passenger_id
      t.string :name
      t.string :email
      t.string :password
      t.string :phoneNumber
      t.string :address

      t.timestamps
    end
    add_index :passengers, :passenger_id, unique: true
  end
end
