class ApplicationController < ActionController::API
  before_action :authenticate

  private

  attr_reader :current_user

  def authenticate
    result = set_current_user
    render json: { message: result[:error_message] }, status: :unauthorized if result[:error_message]
  end

  def set_current_user
    token = request.authorization&.sub('Bearer ', '')
    return { error_message: 'token is required' } unless token

    begin
      decoded_token = JWT.decode(token, ENV.fetch('JWT_SECRET'), true, { algorithm: 'HS256' })
    rescue JWT::ExpiredSignature
      return { error_message: 'token is expired' }
    rescue StandardError
      return { error_message: 'token is invalid' }
    end

    user_id = decoded_token[0]['user_id']
    user = User.find(user_id)
    return { error_message: 'user was not found' } unless user

    @current_user = user
  end
end
