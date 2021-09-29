class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]
  before_action :authorize_refresh_request!, only: [:destroy_by_refresh]

  def create
    user = User.find_by!(email: params[:email])
    if user.authenticate(params[:password])
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload)
      render json: session.login
    else
      render json: 'Invalid user', status: :unauthorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(refresh_by_access_allowed: true)
    tokens = session.login
    session.flush_by_access_payload
  end
end