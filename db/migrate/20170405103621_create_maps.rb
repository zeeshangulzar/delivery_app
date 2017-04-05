class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :name
      t.boolean :active,  default: true
      t.text :polygons

      t.timestamps null: false
    end
  end
end
