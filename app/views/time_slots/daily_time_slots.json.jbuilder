json.time_slots @dates do |date|
  json.date date.date
  json.slots @time_slots.where(date: date.date) do |time_slot|
    json.start_time time_slot.start_time
    json.end_time time_slot.end_time
    json.charges time_slot.charges
  end
end
