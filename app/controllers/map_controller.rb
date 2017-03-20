class MapController < ApplicationController

  def map
    @locations=Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.lon
      marker.infowindow location.name
    end
  end
end
