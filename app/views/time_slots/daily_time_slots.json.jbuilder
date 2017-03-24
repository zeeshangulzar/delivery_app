json.time_slots @dates do |date|
  json.date date.date
  json.slots @time_slots.where(date: date.date) do |time_slot|
    json.start_time date.start_time
    json.end_time date.end_time
    json.charges date.charges
  end
end
