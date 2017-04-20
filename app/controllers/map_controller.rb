class MapController < ApplicationController

  before_action :authenticate_user!,only:[:map]
  before_action :check_polygon, only:[:map]
  before_action :set_map, only: [:destroy, :update_polygon]
  before_action :token_authentication, only: [:service_areas]

  def map
    @map = Map.all.order(:name)
    if @map.present?
      @hash = []
      @map.each do |map|
        poly = Gmaps4rails.build_markers(map.polygons) do |polygon, point|
          point.lat polygon[1]['lat']
          point.lng polygon[1]['lng']
        end
        @hash.push(poly)
      end
    end
  end

  def destroy
    @map.destroy
    respond_to do |format|
      format.html { redirect_to map_path(), notice: 'Polygon is destroyed successfully.' }
      format.json { head :no_content }
    end
  end

  def save_polygon
    @map = Map.create(name: params[:name], polygons: params[:polygons])
  end

  def update_polygon
    @map.polygons = params[:polygons]
    @map.save
  end

  def service_areas
    @service_areas = Map.all
  end

  private
    def check_polygon
      return if params[:name].present? && params[:polygons].present?
    end

    def set_map
      @map = Map.find(params[:id])
    end
end
