class ChangeAmountColumnIntoTranactions < ActiveRecord::Migration
 def up
    change_column :transactions, :amount, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :transactions, :amount, :integer
  end

end
