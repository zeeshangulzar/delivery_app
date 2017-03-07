class Booking < ActiveRecord::Base
  belongs_to :user

  has_one :location, as: :locateable
  has_many :orders

end
