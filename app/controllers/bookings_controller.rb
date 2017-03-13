class BookingsController < ApplicationController

  before_action :check_from
  before_action :check_sender
  before_action :check_slot
  before_action :check_orders
  before_action :check_total_amount

  def booking
    ActiveRecord::Base.transaction do
      booking = Booking.create_booking(params)
      return render json: {error: "booking"+booking.errors.full_messages.to_sentence}, status: 406 unless booking.persisted?

      from = booking.location = Location.save_locateable(params[:from])
      return render json: {error: "from location"+from.errors.full_messages.to_sentence}, status: 406 unless from.persisted?

      params[:orders].each do |order|
        new_order = booking.orders.save_order(order)
        return render json: {error: "new_order"+new_order.errors.full_messages.to_sentence}, status: 406 unless new_order.persisted?
        if order[:invoice].present?
          order[:invoice].each do |item|
            invoice = new_order.line_items.create_invoice(item)
            return render json: {error: "invoice_item"+invoice.errors.full_messages.to_sentence}, status: 406 unless invoice.persisted?
          end
        end
      end
    end
    render json: { message: 'successful'}, status: 200
  end

  private
    def check_from
      return render json: { error: 'Please provide proper from detail'}, status: 404 if params[:from].blank? || params[:from][:address].blank? || params[:from][:lat].blank? || params[:from][:lng].blank?
    end
    def check_sender
      return render json: { error: "Please provide sender's id or details"}, status: 404 if params[:sender].blank?
      return render json: { error: 'Please provide proper sender detail'}, status: 404 if !params[:sender][:id].present? && ( params[:sender][:name].blank? || params[:sender][:cell].blank? || params[:sender][:email].blank? )
    end
    def check_slot
      return render json: { error: 'time_slot is empty'}, status: 404 if params[:time_slot_id].blank?
      timeslot=TimeSlot.find_by_id(params[:time_slot_id])
      return render json: { error: 'Invalid slot_id'}, status: 401 if timeslot.blank?
    end
    def check_orders
      return render json: { error: "Orders can't be empty"}, status: 404 if params[:orders].blank?
    end
    def check_total_amount
      return render json: { error: "total_amount can't be empty"}, status: 404 if params[:total_amount].blank?
    end

end
