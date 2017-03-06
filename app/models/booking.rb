class Booking < ActiveRecord::Base
  belongs_to :user
  has_one :location, as: :locateable

  validates :user_signature, presence: true
end
