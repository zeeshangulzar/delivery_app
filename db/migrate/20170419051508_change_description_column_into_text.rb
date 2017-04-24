class ChangeDescriptionColumnIntoText < ActiveRecord::Migration
  def up
    change_column :configs, :description, :text
  end

  def down
    change_column :configs, :description, :string
  end
end
