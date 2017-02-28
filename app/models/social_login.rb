class SocialLogin < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :platform_name, presence: true
  validates :authentication_id, presence: true
end
