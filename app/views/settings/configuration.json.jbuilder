json.configurations @configs do |config|
  json.title config.title
  json.description format_description(config.description)
end
