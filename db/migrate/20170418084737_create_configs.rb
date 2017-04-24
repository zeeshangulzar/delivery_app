class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :title
      t.string :description
      t.boolean :default, default: false
      t.boolean :api, default: false

      t.timestamps null: false
    end
  end
end
