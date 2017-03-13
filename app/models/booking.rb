class Booking < ActiveRecord::Base
  belongs_to :user

  has_one :location, as: :locateable
  has_many :orders
  belongs_to :time_slot

  def self.create_booking(params)
    booking = self.new
    if params[:sender_id].present?
      booking.user_id = params[:sender_id]
    else
      booking.user_name = params[:sender][:name]
      booking.user_cell = params[:sender][:cell]
      booking.user_email = params[:sender][:email]
    end
    booking.total_amount = params[:total_amount]
    booking.time_slot = TimeSlot.find_by_id(params[:time_slot_id])
    booking.save
    booking
  end

end
