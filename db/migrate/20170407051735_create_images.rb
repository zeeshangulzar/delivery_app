class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :profile, index: true, foreign_key: true
      t.string :attachment

      t.timestamps null: false
    end
  end
end
