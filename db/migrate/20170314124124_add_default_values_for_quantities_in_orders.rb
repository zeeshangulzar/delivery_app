class AddDefaultValuesForQuantitiesInOrders < ActiveRecord::Migration
  def up
    change_column :orders, :small, :integer, default: 0
    change_column :orders, :medium, :integer, default: 0
    change_column :orders, :large, :integer, default: 0
  end

  def down
    change_column :orders, :small, :integer, default: nil
    change_column :orders, :medium, :integer, default: nil
    change_column :orders, :large, :integer, default: nil
  end
end
