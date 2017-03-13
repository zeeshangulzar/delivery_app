class ApplicationController < ActionController::Base

  AUTHENTICATION_TOKEN = 'Basic YW5hX2F1dGhlbnRpY2F0ZWRfdXNlcjpAbkBfdXNlcg=='
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #Prevent CSRF attacks, except for JSON requests (API clients)
  protect_from_forgery unless: -> { request.format.json? }

  # Require authentication and do not set a session cookie for JSON requests (API clients)
  before_action :authenticate_user!, :do_not_set_cookie, if: -> { request.format.json? }

  def token_authentication
    return render json: { error: "authorization can't be nil" }, status: 406 unless request.headers['HTTP_AUTHORIZATION'].present?
    return render json: { error: 'You are not authorized' }, status: 401 unless request.headers['HTTP_AUTHORIZATION'] == AUTHENTICATION_TOKEN
  end

  private

  # Do not generate a session or session ID cookie
  # See https://github.com/rack/rack/blob/master/lib/rack/session/abstract/id.rb#L171
  def do_not_set_cookie
    request.session_options[:skip] = true
  end

  def send_sms(token, cell)
    client = Twilio::REST::Client.new(User::TWILLIO_SID, User::TWILLIO_AUTH)
    client.messages.create to: cell,
    from: User::TWILLIO_NUMBER,
    body: "ANA PIN: #{token}"
  end

  def sms_token
    rand(1111..9999)
  end

end
