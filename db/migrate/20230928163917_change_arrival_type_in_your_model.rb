class ChangeArrivalTypeInYourModel < ActiveRecord::Migration[7.0]
  def change
    change_column :trains, :arrival_time, :time
    change_column :trains, :arrival_date, :date
  end
end
