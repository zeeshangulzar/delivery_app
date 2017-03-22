module V1
  class Users::SessionsController < Devise::SessionsController

    before_action :token_authentication
    before_action :validate_login_details, only: [:create]

    def create
      if params[:cell].present? && params[:password].present?
        user = User.find_by_cell(params[:cell])
        return render json: { error: 'user is inactive' }, status: 422 unless user.sttaus == 'active'
        return render json: {error: "Invalid cell or password"}, status: 401 if user.blank? || !user.valid_password?(params[:password])
        token = Tiddle.create_and_return_token(user, request)
        login = SocialLogin.where(user_id: user.id).last
        social_type = login.blank? ? 'local' : login.platform_name
        return render json: { user_id: user.id, name: user.name, email: user.email, cell: user.cell, role: user.role, type: social_type, authentication_token: token}
      end

      social_id = params[:facebook_id].present? ? params[:facebook_id] : params[:google_id]
      social_login = SocialLogin.where(authentication_id: social_id).last
      return render json: {error: 'Invalid social_login_id'}, status: 401 if social_login.blank?
      user = social_login.user
      return render json: {error: 'User with social_login_id not found'}, status: 404 if user.blank?
      return render json: { error: 'user is inactive' }, status: 422 unless user.sttaus == 'active'
      token = Tiddle.create_and_return_token(user, request)
      return render json: { user_id: user.id, name: user.name, email: user.email, cell: user.cell, role: user.role, type: social_login.platform_name, authentication_token: token}

    end

    def destroy
      render json: { deletion: "destroyed" }
    end

    private

    def validate_login_details
      return if params[:google_id].present? || params[:facebook_id].present? || (params[:cell].present? && params[:password].present?)
      render json: {error: "Please provide cell and password or social_login_id"}, status: 404
    end

  end
end
