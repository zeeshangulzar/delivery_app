class Question < ActiveRecord::Base

has_many :answers

paginates_per 10

private

def self.search(params)
	if params[:start_date].present? && params[:end_date].present?
		start_date = params[:start_date].to_date.beginning_of_day
		end_date = params[:end_date].to_date.end_of_day
		Question.where(:created_at => start_date..end_date).reverse_order
	else
	  self.all.reverse_order
	end
end
end
