class TimeSlot < ActiveRecord::Base
  validates :date, :start_time, :end_time, :charges, presence: true
  has_one :booking

  paginates_per 10

  def self.import_csv(file)
    return if File.extname(file) != ".csv"
    spreadsheet = CSV.new(file.path, nil, :ignore)

    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      p spreadsheet
=begin
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_id(row["id"]) || new
      product.attributes = row.to_hash.slice(*accessible_attributes)
      product.save!
=end
    end

  end

end
