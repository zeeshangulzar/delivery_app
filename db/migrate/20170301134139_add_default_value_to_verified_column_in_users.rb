class AddDefaultValueToVerifiedColumnInUsers < ActiveRecord::Migration
  def up
  change_column :users, :verified, :boolean, default: false
  end

  def down
    change_column :users, :show_attribute, :boolean, default: nil
  end
end
