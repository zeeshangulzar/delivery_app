class LocationsController < ApplicationController
  before_action :get_user

  def save_user_location
    location = Location.save_location(@user, params)
    if location.persisted?
      render json: {message: "successful"}, status: 200
    else
      render json: {error: location.errors.full_messages.to_sentence}, status: 406
    end
  end

  private
  def get_user
    return render json: {error: "user_id can't be nil"}, status: 406 unless params[:user_id].present?
    @user = User.find_by_id(params[:user_id])
    return render json: {error: "invalid user_id"}, status: 401 if @user.blank?
  end

end
