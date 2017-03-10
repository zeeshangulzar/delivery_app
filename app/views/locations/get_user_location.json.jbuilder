json.locations @locations do |locations|
  json.location_id locations.id
  json.place_id locations.place_id
  json.name locations.name
  json.address locations.address
  json.latitude locations.lat
  json.longitude locations.lon
end
