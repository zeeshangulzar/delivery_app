class ChangePrecisionAndScaleOnLocations < ActiveRecord::Migration
  def up
    change_column :locations, :lon, :decimal, precision: 25, scale: 20
    change_column :locations, :lat, :decimal, precision: 25, scale: 20
  end

  def down
    change_column :locations, :lon, :decimal, precision: 15, scale: 10
    change_column :locations, :lat, :decimal, precision: 15, scale: 10
  end
end

