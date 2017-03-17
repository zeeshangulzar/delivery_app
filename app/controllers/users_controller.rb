class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :validate_user_role, only: [:users_by_role]

  def index
    render json: User.all
  end

  def show
    render json: User.find(params[:id])
  end

  def users_by_role
    @users = User.where(role: params[:role]).page(params[:page])
  end

  private

  def validate_user_role
    return redirect_to :root, notice: 'Please provide user role' if params[:role].blank?
    return redirect_to :root, notice: 'Please provide valid user role' unless User::ROLES.include?(params[:role])
  end

end
