class Booking < ActiveRecord::Base

  belongs_to :user
  has_one :location, as: :locateable
  has_many :orders
  belongs_to :time_slot

  validates :time_slot, :total_amount, presence: true
  validates :user_name, :user_cell, :user_email, presence: true, if: 'user_id.blank?'
  validate :validate_user_id, if: 'user_id.present?'

  def self.create_booking(params)
    booking = self.new
    if params[:sender][:id].present?
      booking.user_id = params[:sender][:id]
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

  private
    def validate_user_id
      errors.add(:user_id, "id is invalid") unless User.exists?(self.user_id)
    end

end
