class Transaction < ActiveRecord::Base

  validates :amount, presence: true

  belongs_to :transactionable, polymorphic: true
end
