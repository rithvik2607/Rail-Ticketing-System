class ChangeDepartureTimeTypeInYourModel < ActiveRecord::Migration[7.0]
  def change
    change_column :trains, :departure_time, :time
  end
end
