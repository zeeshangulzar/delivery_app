class Booking < ActiveRecord::Base

  belongs_to :user
  has_one :location, as: :locateable
  has_many :orders
  belongs_to :time_slot

  validates :time_slot, :total_amount, presence: true
  validates :user_name, :user_cell, :user_email, presence: true, if: 'user_id.blank?'

  def self.create_booking(params)
    booking = self.new
    if params[:sender][:id].present?
      user = User.find_by_id(params[:sender][:id])
      if user.blank?
        errors.add(:user_id, "id is invalid")
      else
        booking.user_id = params[:sender][:id]
        booking.user_name = user.name
        booking.user_cell = user.cell
        booking.user_email = user.email
      end
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
