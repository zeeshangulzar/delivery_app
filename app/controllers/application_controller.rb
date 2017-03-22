class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #Prevent CSRF attacks, except for JSON requests (API clients)
  protect_from_forgery unless: -> { request.format.json? }

  # Require authentication and do not set a session cookie for JSON requests (API clients)
  #before_action :authenticate_user!, :do_not_set_cookie, if: -> { request.format.json? }

  def token_authentication
    return render json: { error: "authorization can't be nil" }, status: 406 unless request.headers['HTTP_AUTHORIZATION'].present?
    return if params[:user_id].present?
    return render json: { error: 'You are not authorized' }, status: 401 unless request.headers['HTTP_AUTHORIZATION'] == APP_CONFIG[:token_authorization][:token]
  end

  def validate_user_activation
    return if @user.blank?
    return render json: { error: 'user is inactive' }, status: 422 unless @user.sttaus == 'active'
  end

  private

  # Do not generate a session or session ID cookie
  # See https://github.com/rack/rack/blob/master/lib/rack/session/abstract/id.rb#L171
  def do_not_set_cookie
    request.session_options[:skip] = true
  end


  def after_sign_in_path_for(resource_or_scope)
   user_by_role_users_path('consumer', 'active')
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def send_sms(token, cell)
    client = Twilio::REST::Client.new(APP_CONFIG[:twillio][:sid], APP_CONFIG[:twillio][:auth])
    client.messages.create to: cell,
    from: APP_CONFIG[:twillio][:number],
    body: "ANA PIN: #{token}"
  end

  def set_format
    request.format = 'json'
  end

  def sms_token
    rand(1111..9999)
  end

  helper_method :sms_token

end
