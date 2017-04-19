json.cross_region_rate format_description(@rate.try(:description))
json.areas @service_areas do |area|
  json.name area.name
  json.coordinates area.polygons
end
