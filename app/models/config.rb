class Config < ActiveRecord::Base

  validates :title, :description, presence: true
end
