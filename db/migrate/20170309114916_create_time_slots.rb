class CreateTimeSlots < ActiveRecord::Migration
  def change
    create_table :time_slots do |t|
      t.date :date
      t.string :start_time
      t.string :end_time
      t.integer :charges

      t.timestamps null: false
    end
  end
end
