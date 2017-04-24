@configs.each do |config|
  json.set! config.title.try(:strip), config.description
end
