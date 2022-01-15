class UsersController < ApplicationController
  skip_before_action :authenticate, only: %i[create]

  def create
    user = User.new(user_params)

    if user.save
      token = user.create_auth_token
      render json: { token: token }
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
