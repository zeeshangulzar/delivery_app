class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string  :status, default: 'created'
      t.integer :amount
      t.integer :transactionable_id
      t.string :transactionable_type

      t.timestamps null: false
    end
  end
end
