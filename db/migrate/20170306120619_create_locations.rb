class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.decimal  :lat, precision: 15, scale: 10
      t.decimal  :lon, precision: 15, scale: 10
      t.integer :place_id
      t.integer :locateable_id
      t.string :locateable_type

      t.timestamps null: false
    end
  end
end
