class LineItem < ActiveRecord::Base

  belongs_to :order
  validates :name, :order_id, :price, :quantity, presence: true

  def self.save_invoice(item)
    line_item = self.new
    line_item.name = item[:name]
    line_item.quantity = item[:quantity]
    line_item.image = item[:image]
    line_item.price = item[:price]
    line_item.save
    line_item
  end

end
