module V1
  class Users::SessionsController < Devise::SessionsController
    skip_before_action :verify_signed_out_user

    def create
      user = warden.authenticate!(:scope => :user)
      token = Tiddle.create_and_return_token(user, request)
      render json: { authentication_token: token }
    end

    def destroy
      render json: { deletion: "destroyed" }
    end

  end
end
