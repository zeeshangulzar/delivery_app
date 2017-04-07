class Profile < ActiveRecord::Base

  belongs_to :user
  has_one :image
  validates :address, :plate_name, :license_number, :vehicle_make, presence: true
end

