class LineItem < ActiveRecord::Base

  belongs_to :order
  validates :name, :order_id, :price, presence: true

  def self.create_invoice(item)
    line_item = self.new
    if item[:name].present? && item[:quantity].present? && item[:price].present?
      line_item.name = item[:name]
      line_item.quantity = item[:quantity]
      line_item.image = item[:image]
      line_item.price = item[:price]
      line_item.save
    end
    line_item
  end

end
