class AddPaymentTypeIntoBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :payment_method, :string
  end
end
