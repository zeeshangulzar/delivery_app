class LineItem < ActiveRecord::Base

  belongs_to :order
  validates :name, :order_id, :price, presence: true
end
