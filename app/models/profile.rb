class Profile < ActiveRecord::Base

  belongs_to :user
  validates :address, :plate_name, :license_number, :vehicle_model, :vehicle_type, :vehicle_make, presence: true
end

