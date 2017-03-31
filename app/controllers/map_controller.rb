class MapController < ApplicationController

  before_action :authenticate_user!,only:[:map]

  def map
    @locations=Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.lon
      marker.infowindow location.name
    end
  end
end
