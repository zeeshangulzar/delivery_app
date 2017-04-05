class MapController < ApplicationController

  before_action :authenticate_user!,only:[:map]
  before_action :check_polygon, only:[:map]

  def map
    @map = Map.all
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

  def save_polygon
    Map.create(name: params[:name], polygons: params[:polygons])
    redirect_to map_path()
  end

  private
    def check_polygon
      return if params[:name].present? && params[:polygons].present?
    end
end
