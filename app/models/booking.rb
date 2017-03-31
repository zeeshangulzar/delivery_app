class Booking < ActiveRecord::Base

  belongs_to :user
  has_one :location, as: :locateable
  has_many :orders
  belongs_to :time_slot

  paginates_per 10

  validates :time_slot, :total_amount, presence: true
  validates :user_name, :user_cell, :user_email, presence: true, if: 'user_id.blank?'
  validate :validate_sender_id, if: 'user_id.present?'

  scope :ordered, -> { order('created_at DESC') }

  def self.create_booking(params)
    booking = self.new
    if params[:sender][:id].present?
        user = User.find_by_id(params[:sender][:id])
        booking.user_id = params[:sender][:id]
        unless user.blank?
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

  def self.get_list(params)
    bookings = self.ordered
    bookings = bookings.joins("INNER JOIN locations on bookings.id = locateable_id AND locateable_type = 'Booking'").where("locations.address LIKE (?)", "%#{params[:from].strip}%") if params[:from].present?
    bookings = bookings.where(status: params[:status]) if params[:status].present?
    bookings = bookings.where("bookings.created_at BETWEEN ? AND ?", Time.parse(params[:date]).beginning_of_day, Time.parse(params[:date]).end_of_day) if params[:date].present?
    bookings = bookings.page(params[:page])
    bookings
  end

  private
    def validate_sender_id
      errors.add(:base, "sender id is invalid") if user_id.present? && user_name.blank?
    end

end
