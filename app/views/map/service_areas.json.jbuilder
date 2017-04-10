json.cross_region_rate '20'
json.areas @service_areas do |area|
  json.name area.name
  json.coordinates area.polygons
end
