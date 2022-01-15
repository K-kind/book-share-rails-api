class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
  validates :description, length: { maximum: 255 }

  def create_auth_token
    exp = (Time.zone.now + 30.days).to_i
    payload = { user_id: id, exp: exp }
    secret = ENV.fetch('JWT_SECRET')
    JWT.encode(payload, secret, 'HS256')
  end
end
