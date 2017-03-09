class LocationsController < ApplicationController
  before_action :get_user
  before_action :check_location, except: [:save_user_location, :get_user_location]
  before_action :check_page, only: [:get_user_location]
  before_action :user_authentication

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

  def update_user_location
    @location.lat = params[:latitude] if params[:latitude].present?
    @location.lon = params[:longitude] if params[:longitude].present?
    @location.address = params[:address] if params[:address].present?
    @location.name = params[:name] if params[:name].present?
    @location.place_id = params[:place_id] if params[:place_id].present?

    if @location.save
      render json: { message: 'Successful' }, status: 200 if @location.save
    else
      render json: { error: @location.error.full_messages.to_sentence }, status: 401
    end
  end

  def get_user_location
    @locations = @user.locations.page(params[:page])
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

    def check_page
      return params[:page] = 1 if params[:page].blank?
    end

    def user_authentication
      return render json: { error: "authentication_token can't be nil" }, status: 406 unless params[:authentication_token].present?
      token = Tiddle::TokenIssuer.build.find_token(@user, params[:authentication_token])
      return render json: { error: 'You are not authorized' }, status: 401 if token.blank?
    end
end
