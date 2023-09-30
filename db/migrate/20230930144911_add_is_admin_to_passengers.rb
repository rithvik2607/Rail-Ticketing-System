class AddIsAdminToPassengers < ActiveRecord::Migration[7.0]
  def change
    add_column :passengers, :is_admin, :boolean
  end
end
