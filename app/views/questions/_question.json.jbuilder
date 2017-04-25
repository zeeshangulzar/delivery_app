json.extract! question, :id, :content, :active, :created_at, :updated_at
json.url question_url(question, format: :json)
