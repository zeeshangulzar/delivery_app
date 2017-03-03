module V1
  class Users::PasswordsController < Devise::PasswordsController
  before_action :check_cell
  before_action :check_password, only: [:update]

    def recover
      user=User.find_by_cell(params[:cell])
      if user.blank?
        render json: {error: "invalid cell number"}, status: 404
      else
        user.verified_token=rand(1111..9999)
        user.save
        user.send_sms
        render json: {msg: "verification code has been sent"}, status: 201
      end
    end

    def update
      user=User.find_by_cell(params[:cell])
      unless user.blank?
        if params[:code]==user.verified_token
          user.password=params[:password]
          if user.save
            render json: {msg: "password updated successfully"}, status: 201
          else
            render json: user.errors, status: 406
          end
        else
          render json: {error: "invalid verification code"}, status: 404
        end
      else
        render json: {error: "invalid cell number"}, status: 404
      end
    end

    private
      def check_cell
        unless params[:cell].present?
          render json: {error: "cell field is empty"}, status: 406
        end
      end
      def check_password
        unless params[:password].present?
          render json: {error: "password field is empty"}, status: 406
        end
      end

  end
end
