class AddTimeSlotRefToBooking < ActiveRecord::Migration
  def change
    add_reference :bookings, :time_slot, index: true, foreign_key: true
  end
end
