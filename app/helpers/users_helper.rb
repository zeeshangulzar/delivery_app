module UsersHelper

  def is_verified(user)
    user.verified? ? 'Yes' : 'No'
  end

  def status_link(status)
    status == 'active' ? 'Block' : 'Active'
  end
end
