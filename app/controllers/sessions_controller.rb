class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[create]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = user.create_auth_token
      render json: { token: token }
    else
      render json: { message: 'email or password is wrong' }, status: :unauthorized
    end
  end
end
