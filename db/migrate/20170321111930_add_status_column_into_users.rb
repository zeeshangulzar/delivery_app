class AddStatusColumnIntoUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, limit: 10, default: 'active'
    add_index :users, :status
  end
end
