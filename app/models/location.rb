class Location < ActiveRecord::Base
   belongs_to :locateable, polymorphic: true

   validates :name, :lat, :lon, presence: true
end
