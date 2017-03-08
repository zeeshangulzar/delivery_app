class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.integer  :booking_id
      t.boolean  :pay_by_sender
      t.text     :instruction
      t.integer  :amount
      t.string   :tracking_id
      t.string   :status, null: false, default: 'processing'
      t.integer  :driver_id
      t.integer  :recipient_id
      t.string   :recipient_name
      t.string   :recipient_cell
      t.string   :recipient_email
      t.string   :recipient_signature
      t.integer  :small
      t.integer  :medium
      t.integer  :large

      t.timestamps null: false
    end
  end
end
