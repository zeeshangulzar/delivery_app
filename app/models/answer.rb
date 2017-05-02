class Answer < ActiveRecord::Base
	belongs_to :question

	private

	def self.save_answer(answer)
	Answer.create(answer)
	end

end
