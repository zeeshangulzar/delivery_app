class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, foreign_key: true
      t.string :address
      t.string :plate_name
      t.string :nationality
      t.string :license_number
      t.string :vehicle_model
      t.string :vehicle_type
      t.string :vehicle_make

      t.timestamps null: false
    end
  end
end
