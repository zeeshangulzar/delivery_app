class BookingsController < ApplicationController

  before_action :authenticate_user!,only:[:index,:show]
  before_action :check_sender, only: [:save_booking]
  before_action :populate_user_id, only: [:save_booking]
  before_action :token_authentication, only: [:save_booking]
  before_action(only: [:save_booking]) { user_authentication() if params[:user_id].present? }
  before_action :validate_user_activation, only: [:save_booking]
  before_action :check_from, only: [:save_booking]
  before_action :check_slot, only: [:save_booking]
  before_action :check_orders, only: [:save_booking]
  before_action :set_booking, only: [:show]

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
      return render json: { message: 'successful', booking_id: booking.id }, status: 200 if booking.persisted?
    end
  end

  def index
    @status = Booking.pluck(:status).uniq
    @bookings = Booking.get_list(params)

  end

  def show
    @orders = @booking.orders.page(params[:page])
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

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def user_authentication
      @user = User.find_by_id(params[:user_id])
      return render json: { error: 'Invalid sender_id' }, status: 401 if @user.blank?
      return render json: { error: "authorization can't be nil" }, status: 406 unless request.headers['HTTP_AUTHORIZATION'].present?
      token = Tiddle::TokenIssuer.build.find_token(@user, request.headers['HTTP_AUTHORIZATION'])
      return render json: { error: 'You are not authorized' }, status: 401 if token.blank?
    end

    def populate_user_id
      params[:user_id] = params[:sender][:id] if params[:sender][:id].present?
    end

end
