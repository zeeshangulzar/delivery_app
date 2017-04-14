class PaymentsController < ApplicationController

  before_action :token_authentication, only: [:booking_payment]
  before_action(only: [:booking_payment]) { user_authentication() if params[:user_id].present? }
  before_action :payment_parameters, only: [:booking_payment]
  before_action :get_booking, only: [:booking_payment]

  def booking_payment
    ActiveRecord::Base.transaction do
      @booking.update(pay_by_sender: params[:pay_by_sender], payment_method: params[:payment_type])
      @payment = @booking.payments.create(amount: params[:amount]) if params[:pay_by_sender].present?
    end
    return render json: { errors: @booking.errors }, status: 422 if @booking.errors.present?
    return render json: { errors: @payment.errors }, status: 422 if @payment.present? && @payment.errors.present?
    return render json: { message: 'successful' }, status: 200
  end

  private

    def payment_parameters
      return render json: { errors: 'pay_by_sender is blank' }, status: 422 if params[:pay_by_sender].blank?
      return render json: { errors: 'booking_id is blank' },    status: 422  if params[:booking_id].blank?
      return render json: { errors: 'payment_type is blank' },  status: 422  if params[:payment_type].blank?
      return render json: { errors: 'amount is blank' },  status: 422  if params[:amount].blank?
    end

    def get_booking
      @booking = Booking.find_by_id(params[:booking_id])
      return render json: { errors: 'Invalid booking_id' }, status: 422 if @booking.blank?
    end

    def user_authentication
      @user = User.find_by_id(params[:user_id])
      return render json: { error: 'Invalid sender_id' }, status: 401 if @user.blank?
      return render json: { error: "authorization can't be nil" }, status: 406 unless request.headers['HTTP_AUTHORIZATION'].present?
      token = Tiddle::TokenIssuer.build.find_token(@user, request.headers['HTTP_AUTHORIZATION'])
      return render json: { error: 'You are not authorized' }, status: 401 if token.blank?
    end
end
