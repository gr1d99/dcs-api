# frozen_string_literal: true

module JWTHelper
  SECRET_KEY = ENV['SECRET_KEY_BASE']

  def decode_jwt_token(response)
    jwt = response.headers['Authorization'].split(' ').last
    JWT.decode(jwt, SECRET_KEY)
  end
end

RSpec.configure do |config|
  config.include JWTHelper, type: :request
end
