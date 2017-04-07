class TimeSlot < ActiveRecord::Base
  validates :date, :start_time, :end_time, :charges, presence: true
  has_one :booking, dependent: :delete

  paginates_per 10

end
