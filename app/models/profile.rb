class Profile < ActiveRecord::Base

  belongs_to :user
  has_one :image, dependent: :delete
  validates :address, :plate_name, :license_number, :vehicle_make, presence: true

  def save_profile(params)
    self.nationality    = params[:nationality]
    self.address        = params[:address]
    self.vehicle_make   = params[:make]
    self.vehicle_model  = params[:model]
    self.vehicle_type   = params[:type]
    self.license_number = params[:license_number]
    self.plate_name     = params[:plate_name]
    self.save
    self
  end
end

