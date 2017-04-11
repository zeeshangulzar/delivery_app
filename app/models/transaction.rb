class Transaction < ActiveRecord::Base

  validates :amount, presence: true
end
