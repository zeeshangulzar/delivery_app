class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer  :order_id
      t.string   :name
      t.integer  :quantity
      t.string   :image
      t.integer  :price

      t.timestamps null: false
    end
  end
end
