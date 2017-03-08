json.locations @locations do |locations|
  json.id locations.id
  json.id locations.place_id
  json.name locations.name
  json.address locations.address
  json.latitude locations.lat
  json.longitude locations.lon
end
