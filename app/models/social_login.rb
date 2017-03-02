class SocialLogin < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :platform_name, presence: true
  validates :authentication_id, presence: true, uniqueness: true

  def self.create_social_login(params, user_id)
    if params[:facebook_id].present?
      platform_name = "facebook"
      authentication_id = params[:facebook_id]
    elsif params[:google_id].present?
      platform_name = "google"
      authentication_id = params[:google_id]
    end

    return login=SocialLogin.create(user_id: user_id, platform_name: platform_name, authentication_id: authentication_id)

  end

  def self.check_social_login(params)
    if params[:facebook_id].present?
      platform_name = "facebook"
      authentication_id = params[:facebook_id]
    elsif params[:google_id].present?
      platform_name = "google"
      authentication_id = params[:google_id]
    end
    login=SocialLogin.find_by(platform_name: platform_name, authentication_id: authentication_id)
    if login.blank?
      return login
    else
      return login.user
    end
  end

  def self.get_social_login(user)
    login=SocialLogin.find_by_user_id(user.id)
    return login
  end

end
