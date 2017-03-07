class Location < ActiveRecord::Base
   belongs_to :locateable, polymorphic: true

   validates :lat, :lon, :address, presence: true

   paginates_per 10

   def self.save_location(user, params)
     location = self.new
     location.lat = params[:latitude]
     location.lon = params[:longitude]
     location.address = params[:address]
     location.name = params[:name]
     location.place_id = params[:place_id]
     location.locateable = user
     location.save
     location
   end
end
