class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|

      t.string   :status, null: false, default: 'processing'
      t.integer  :user_id
      t.string   :user_name
      t.string   :user_cell
      t.string   :user_email
      t.string   :user_signature

      t.timestamps null: false
    end
  end
end
