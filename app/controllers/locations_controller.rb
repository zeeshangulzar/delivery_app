class LocationsController < ApplicationController
  before_action :get_user
  before_action :check_location, only: [:delete_user_location]

  def save_user_location
    location = Location.save_location(@user, params)
    if location.persisted?
      render json: { message: 'Successful' }, status: 200
    else
      render json: { error: location.errors.full_messages.to_sentence }, status: 406
    end
  end

  def delete_user_location
    if @location.destroy
      render json: { message: 'Successful' }, status: 200
    else
      render json: { error: 'Invalid location_id' }, status: 401
    end
  end

  private

    def get_user
      return render json: { error: "user_id can't be nil" }, status: 406 unless params[:user_id].present?
      @user = User.find_by_id(params[:user_id])
      return render json: { error: 'Invalid user_id' }, status: 401 if @user.blank?
    end

    def check_location
      return render json: { error: "Location_id can't be nil" }, status: 406 unless params[:location_id].present?
      @location = @user.locations.where(id: params[:location_id]).last
      return render json: { error: 'Invalid user_id or location_id' }, status: 401 if @location.blank?
    end
end
