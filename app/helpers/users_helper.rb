module UsersHelper

  def is_verified(user)
    user.verified? ? 'Yes' : 'No'
  end
end
