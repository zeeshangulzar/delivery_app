class Profile < ActiveRecord::Base

  belongs_to :user
  has_one :image, dependent: :delete
  validates :address, :plate_name, :license_number, :vehicle_make, presence: true
end

