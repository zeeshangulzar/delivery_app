class AddDriverIdInBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :driver_id, :integer
  end
end
