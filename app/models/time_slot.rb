class TimeSlot < ActiveRecord::Base
  validates :date, :start_time, :end_time, :charges, presence: true
  has_one :booking

  paginates_per 10

  require 'time'

  def self.import_csv(file)
    csv = CSV.read(file.open, headers:true)
    return "Wrong Headers" if csv.headers[0] != "date" || csv.headers[1] != "start_time" || csv.headers[2] != "end_time" || csv.headers[3] != "charges"
    ids = []
    c = 2
    ActiveRecord::Base.transaction do
      csv.each do |row|
        if validate_date_time(row["date"]) && validate_date_time(row["start_time"]) && validate_date_time(row["end_time"]) && validate_charges(row["charges"])
          begin
            TimeSlot.create! row.to_hash
          rescue
            ids.push(c)
          end
        else
          ids.push(c)
        end
        c += 1
      end
      raise ActiveRecord::Rollback unless ids.blank?
    end
    return ids.blank? ? "Time slots imported successfully." : "Please correct data at row #{ids}"
  end

  private

    def self.validate_date_time(date_time)
      return false if date_time.blank?
      begin
        Time.parse(date_time)
        return true
      rescue
        return false
      end
    end

    def self.validate_charges(charges)
      return charges.present? && charges.to_i.is_a?(Integer)
    end

end
