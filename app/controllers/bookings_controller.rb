class BookingsController < ApplicationController

  before_action :check_from
  before_action :check_sender
  before_action :check_slot
  before_action :check_orders

  def save_booking
    ActiveRecord::Base.transaction do
      booking = Booking.create_booking(params)
      return render json: {error: booking.errors.full_messages.to_sentence}, status: 406 unless booking.persisted?

      from = booking.build_location.save_locateable(params[:from])
      render json: {error: from.errors.full_messages.to_sentence}, status: 406 unless from.persisted?
      return raise ActiveRecord::Rollback unless from.persisted?

      params[:orders].each.with_index do |order, order_index|
        new_order = booking.orders.save_order(order)
        render json: {order_id: order_index, error: new_order.errors.full_messages.to_sentence}, status: 406 unless new_order.persisted?
        return raise ActiveRecord::Rollback unless new_order.persisted?

        to = new_order.build_location.save_locateable(order[:to])
        render json: {order_id: order_index, error: to.errors.full_messages.to_sentence}, status: 406 unless to.persisted?
        return raise ActiveRecord::Rollback unless to.persisted?

        if order[:invoice].present?
          order[:invoice].each.with_index do |item, item_index|
            invoice = new_order.line_items.save_invoice(item)
            render json: {order_id: order_index, item_id: item_index, error: invoice.errors.full_messages.to_sentence}, status: 406 unless invoice.persisted?
            return raise ActiveRecord::Rollback unless invoice.persisted?
          end
        end
      end
      return render json: { message: 'successful'}, status: 200 if booking.persisted?
    end
  end

  private
    def check_from
      return render json: { error: 'Please provide proper from detail'}, status: 404 if params[:from].blank?
    end
    def check_sender
      return render json: { error: "Please provide sender's id or details"}, status: 404 if params[:sender].blank?
    end
    def check_slot
      return render json: { error: 'time_slot is empty'}, status: 404 if params[:time_slot_id].blank?
      time_slot = TimeSlot.find_by_id(params[:time_slot_id])
      return render json: { error: 'Invalid slot_id'}, status: 401 if time_slot.blank?
    end
    def check_orders
      return render json: { error: "orders can't be empty"}, status: 404 if params[:orders].blank?
    end

end
