class AddPayBySenderInBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :pay_by_sender, :boolean
  end
end
