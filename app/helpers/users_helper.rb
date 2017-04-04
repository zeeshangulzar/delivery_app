module UsersHelper

  def is_verified(user)
    user.verified? ? 'Yes' : 'No'
  end

  def status_link(status)
    status == 'active' ? 'Block' : 'Active'
  end

  def user_index_title
    role = params[:role] == 'consumer' ? 'Customers' : 'Drivers'
    [params[:status].try(:titleize), role].join(' ')
  end
end
