module V1
  class Users::RegistrationsController < Devise::RegistrationsController
    before_action :get_user

    def create
      user = User.create(create_params)
      unless user.blank?
        check=true
        if (params[:facebook_id].present? || params[:google_id].present?)
          login = SocialLogin.create_social_login(params, user)
          unless login.blank?
            check=false
            #render json: {error: "social id already exists"}, status: 406
            render json: login.errors, status: 406
          end
        end
        if check
          render json: {signup: "successful"}, status: 201
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
