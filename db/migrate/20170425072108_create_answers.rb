class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :content
      t.integer :count
      t.integer :question_id

      t.timestamps null: false
    end
  end
end
