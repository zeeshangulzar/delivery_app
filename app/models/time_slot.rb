class TimeSlot < ActiveRecord::Base
  validates :date, :start_time, :end_time, :charges, presence: true
  has_one :booking

  paginates_per 10

  def self.import_csv(file)
    return if File.extname(file.original_filename) != ".csv"
    CSV.foreach(file.path, headers: true) do |row|
      TimeSlot.create! row.to_hash
    end
  end

end
