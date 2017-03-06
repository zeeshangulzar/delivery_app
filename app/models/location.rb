class Location < ActiveRecord::Base
   belongs_to :locateable, polymorphic: true

   validates :name, :lat, :lon, presence: true

   def self.save_location(user, params)
     location = self.new
     location.lat = params[:latitude]
     location.lon = params[:longitude]
     location.name = params[:name]
     location.place_id = params[:place_id]
     location.locateable = user
     location.save
     return location
   end
end
