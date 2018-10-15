# frozen_string_literal: true

require_relative '../../app/lib/dcs_jwt'

module DcsJwtHelper
  def jwt_exp(seconds: 60)
    (Time.now + seconds).to_i
  end

  def jwt_nbf
    Time.now.to_i
  end

  def valid_payload(user)
    { email: user.email,
      exp: jwt_exp,
      nbf: jwt_nbf }
  end

  def expired_payload
    { email: 'test@example.com',
      exp: (jwt_exp - 61),
      nbf: (jwt_exp - 61) }
  end

  def expired_jwt_token
    JWT.encode(
      expired_payload,
      DcsJwtDefaults::HMAC_SECRET,
      DcsJwtDefaults::ALGORITHM
    )
  end

  def valid_jwt_token(user)
    JWT.encode(
      valid_payload(user),
      DcsJwtDefaults::HMAC_SECRET,
      DcsJwtDefaults::ALGORITHM
    )
  end
end

RSpec.configure do |config|
  config.include(DcsJwtHelper)
end
