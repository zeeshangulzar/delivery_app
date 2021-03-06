module V1
  class Users::RegistrationsController < Devise::RegistrationsController

    before_action :token_authentication
    before_action :validate_verification_user, only: [:verify]
    before_action :validate_user_activation, only: [:verify]
    before_action :get_user, except: [:verify, :guest_verify, :update_profile, :resend_sms]
    before_action :non_admin_users, only: [:verify]
    before_action :check_cell, only: [:guest_verify, :resend_sms]
    before_action :find_user_by_cell, only: [:resend_sms]
    before_action :check_params_presense, only: [:update_profile]
    before_action :find_user_by_id, only: [:update_profile]
    before_action :user_authentication, only: [:update_profile]

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
        if params[:verified].present?
          user.verified = true;
          user.save
          token = Tiddle.create_and_return_token(user, request)
          return render json: { user_id: user.id, name: user.name, email: user.email, cell: user.cell, role: user.role, type: 'local', authentication_token: token}
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

    def update_profile
      params[:verified] = false unless @user.cell == params[:cell]
      @user.update_attributes(update_params)
      @user.send_sms unless @user.cell == params[:cell]
      if @user.errors.present?
        return render json: { error: @user.errors.full_messages.to_sentence}, status: 422
      else
      token = Tiddle.create_and_return_token(@user, request)
      return render json: { user_id: @user.id, name: @user.name, email: @user.email, cell: @user.cell, role: @user.role, authentication_token: token}
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

    def guest_verify
      token = sms_token
      send_sms(token, params[:cell])
      render json: {code: token}, status: 200
    end

    def resend_sms
      return render json: {error: "user already verified"}, status: 409 if @user.verified?
      send_sms(@user.verified_token, params[:cell])
      render json: {code: @user.verified_token, message: 'successful'}, status: 200
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

    def find_user_by_id
    @user = User.find_by_id(params[:user_id])
    return render json: { error: 'User not found'}, status: 404 if @user.blank?
    end

    def find_user_by_cell
      @user = User.find_by_cell(params[:cell])
      return render json: { error: 'User not found'}, status: 404 if @user.blank?
    end

    def check_params_presense
      return render json: { error: "Id can't be nil"}, status: 404 if params[:user_id].blank?
      return render json: { error: "Cell can't be nil"}, status: 404 if params[:cell].blank?
      return render json: { error: "Name can't be nil"}, status: 404 if params[:name].blank?
      return render json: { error: "Email can't be nil"}, status: 404 if params[:email].blank?
      return render json: { error: "password can't be nil"}, status: 404 if params[:password].blank?
    end

    def create_params
      params.permit(:cell, :name, :password, :email, :role)
    end

    def update_params
       params.permit(:cell, :name, :password, :email, :id, :verified)
    end


    def check_cell
      return render json: { error: "Cell can't be nil"}, status: 404 if params[:cell].blank?
    end

  end

end
