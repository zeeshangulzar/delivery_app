module V1
  class Users::RegistrationsController < Devise::RegistrationsController
    before_action :get_user

    def create
      user = User.create(create_params)
      unless user.id.nil?
        check=true
        if (params[:facebook_id].present? || params[:google_id].present?)
          login = SocialLogin.create_social_login(params, user.id)
          if login.id.nil?
            if !user.id.nil? && login.id.nil?
              User.delete(user.id)
            end
            check=false
            render json: {error: "social_id already exists"}, status: 409
          end
        end
        if check
          render json: {signup: "successful"}, status: 201
          user.verified_token=rand(1111..9999)
          user.save
          user.send_sms
        end
      else
        render json: user.errors, status: 406
      end
    end

    private
    def get_user
      if params[:cell].present?
        user = User.find_by_cell(params[:cell])
        if user.present?
          if user.verified?
            render json: {error: "user already exits"}, status: 409
          else
            #send response to mobile
            render json: {user_id: user.id}, status: 409
          end
        end
      end
    end

    def create_params
      params.permit(:cell, :name, :password, :email, :role)
    end
  end

end
