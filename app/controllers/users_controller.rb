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

  def show
    @bookings = @user.bookings.includes(:location).ordered.page(params[:page])
    @recieved_order = Order.where(recipient_id: @user.id).count
    @sent_order = @user.bookings.joins(:orders).count - @recieved_order
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
