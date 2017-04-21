@configs.each do |config|
  json.set! config.title, config.description
end
