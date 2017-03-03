module V1
  class Users::SessionsController < Devise::SessionsController

    def create
      if !params[:password].present?
        render json: {error: "password can't be nil"}, status: 404

      elsif params[:cell].present?
        user = User.find_by_cell(params[:cell])
        if user.blank? || !user.valid_password?(params[:password])
          render json: {error: "invalid cell or password"}, status: 401
        else
          token = Tiddle.create_and_return_token(user, request)
          login=SocialLogin.get_social_login(user)
          if login.blank?
            render json: {user_id: user.id, name: user.name, email: user.email, cell: user.cell, role: user.role, authentication_token: token}
          else
            render json: {user_id: user.id, name: user.name, email: user.email, cell: user.cell, role: user.role, "#{login.platform_name}": login.authentication_id, authentication_token: token}
          end
        end

      elsif (params[:facebook_id].present? || params[:google_id].present?)
        user = SocialLogin.check_social_login(params)
        if user.blank? || !user.valid_password?(params[:password])
          render json: {error: "invalid social_id or password"}, status: 401
        else
          token = Tiddle.create_and_return_token(user, request)
          render json: {user_id: user.id, name: user.name, email: user.email, cell: user.cell, authentication_token: token}
        end

      else
        render json: {error: "cell or social_id can't be nil"}, status: 404
      end

    end

    def destroy
      render json: { deletion: "destroyed" }
    end

  end
end
