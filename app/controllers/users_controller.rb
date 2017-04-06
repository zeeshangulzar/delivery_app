class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :validate_user_role, only: [:users_by_role]
  before_action :set_user, only: [:show, :update_status]

  def index
    render json: User.all
  end

  def show
    render json: User.find(params[:id])
  end

  def users_by_role
    @users = User.get_list(params)
  end

  def new
    @user = User.new(role: 'driver')
    @profile = @user.build_profile
  end

  def save_driver
    # p "1"*100
    # p @user
    @user, @profile = User.save_driver(params)
    p "*"*100
    # p @user
    # p @user.errors
    p @profile
    p @profile.errors
    if @user.errors.present? && @profile.errors.present?
      # p "5"*100
      # p @profile.errors.messages
      @profile.errors.messages.map do |key, error|
        # p "2"*100
        # p key
        # p error
        @user.errors.add(key, error.first)
      end
      return render 'new', error: @user.errors.full_messages
    end

    return render 'new', error: @user.errors.full_messages if @user.errors.present?
    return render 'new', error: @profile.errors.full_messages if @profile.errors.present?
    return redirect_to user_by_role_users_path('driver', 'active'), success: 'Driver is added successfully'

  end

  def show
    @bookings = @user.bookings.includes(:location).ordered.page(params[:page])
    @recieved_order = Order.where(recipient_id: @user.id).count
    @sent_order = @user.bookings.joins(:orders).count
  end

  def update_status
    flag = @user.update_status
    return redirect_to :back , notice: 'User status is updated successfully' if flag.errors.blank?
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def validate_user_role
    return redirect_to :root, notice: 'Please provide user role' if params[:role].blank?
    return redirect_to :root, notice: 'Please provide valid user role' unless User::ROLES.include?(params[:role])
  end

end
