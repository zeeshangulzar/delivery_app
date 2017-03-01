class CreateSocialLogins < ActiveRecord::Migration
  def change
    create_table :social_logins do |t|
      t.string :platform_name
      t.string :authentication_id

      t.timestamps null: false
    end
  end
end
