
json.questions @questions do |question|
  json.question_id question.id
  json.content question.content
end