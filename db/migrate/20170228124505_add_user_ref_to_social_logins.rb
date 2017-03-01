class AddUserRefToSocialLogins < ActiveRecord::Migration
  def change
    add_reference :social_logins, :user, index: true, foreign_key: true
  end
end
