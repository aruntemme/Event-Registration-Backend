class SignupController < ApplicationController
  def create
    #!check if user already exists?
    if User.exists?(:email => params[:email])
        render json: {error: "A user with this email already exists"}, status: :unprocessable_entity
    else 
      user = User.new(user_params)

      if user.save
        payload = {user_id: user.id}
        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)

        render json: session.login
      else 
        render json: {error: user.error}, status: :unprocessable_entity
      end
       
    end
  end


  private 

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
