module V1
  class Users::PasswordsController < Devise::PasswordsController

    before_action :token_authentication
    before_action :check_cell
    before_action :validate_user
    before_action :check_password, only: [:update]
    before_action :validate_verification_token, only: [:update]

    def recover
      @user.update(verified_token: sms_token)
      @user.send_sms
      return render json: {message: "verification code has been sent"}, status: 200
    end

    def update
      @user.update(password: params[:password])
      return render json: {message: "password updated successfully"}, status: 200 if @user.errors
      return render json: {error: user.errors.full_messages.to_sentence}, status: 406
    end

    private

      def validate_user
        @user = User.find_by_cell(params[:cell])
        return render json: {error: "invalid cell number"}, status: 404 if @user.blank?
      end

      def validate_verification_token
        return render json: {error: "invalid verification code"}, status: 404 unless params[:code] == @user.verified_token
      end

      def check_cell
        return render json: {error: "cell field is empty"}, status: 406 if params[:cell].blank?
      end

      def check_password
        return render json: {error: "password field is empty"}, status: 406 if params[:password].blank?
      end

  end
end
