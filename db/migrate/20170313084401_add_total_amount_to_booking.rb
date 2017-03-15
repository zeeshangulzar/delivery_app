class AddTotalAmountToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :total_amount, :integer
  end
end
