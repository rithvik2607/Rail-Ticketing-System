class CreateCreditCards < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_cards do |t|
      t.string :name
      t.string :card_number
      t.date :expiration_date
      t.string :cvv

      t.timestamps
    end
  end
end
