module V1
  class Users::RegistrationsController < Devise::RegistrationsController

    before_action :validate_verification_user, only: [:verify]
    before_action :get_user, except: [:verify]
    before_action :non_admin_users, only: [:verify]

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
          render json: {message: "successful"}, status: 200
          user.verified_token=rand(1111..9999)
          user.save
          user.send_sms
        end
      else
        render json: {error: user.errors.full_messages.to_sentence}, status: 406
      end
    end

    def verify
      @user.verified = true
      # a temperry solution for password issue
      flag = @user.save(validate: false)
      return render json: @user.verification_json(request) if flag
      return render json: { error: @user.errors.full_messages.to_sentence}, status: 422 unless flag
    end

    def delete
      AuthenticationToken.where(:user_id => params[:id]).destroy_all
      SocialLogin.where(:user_id => params[:id]).destroy_all
      User.delete(params[:id])
      render json: {message: "user deleted: #{params[:id]}"}, status: 200
    end


  private
    def validate_verification_user
      return render json: { error: 'Cell is empty'}, status: 404 if params[:cell].blank?
      return render json: { error: 'code is empty'}, status: 404 if params[:code].blank?
      @user =  User.find_by_cell_and_verified_token(params[:cell], params[:code])
      return render json: { error: 'User not found'}, status: 404 if @user.blank?
      return render json: { error: 'User is already verified'}, status: 422 if @user.verified?
    end

    def non_admin_users
      return unless @user.role == 'admin'
      return render json: { error: 'User role is invalid for verification'}, status: 422
    end

    def get_user
      if params[:cell].present?
        user = User.find_by_cell(params[:cell])
        if user.present?
          if user.verified?
            render json: {error: "user already exits"}, status: 409
          else
            login=SocialLogin.where(user: user)
            if login.blank?
              login = SocialLogin.create_social_login(params, user.id)
            end
            user.send_sms
            render json: {message: "successful"}, status: 200
          end
        end
      end
    end

    def create_params
      params.permit(:cell, :name, :password, :email, :role)
    end
  end

end
