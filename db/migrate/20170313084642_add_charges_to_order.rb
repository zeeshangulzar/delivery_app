class AddChargesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :charges, :integer
  end
end
