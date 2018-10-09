# frozen_string_literal: true

module DcsJwtDefaults
  HMAC_SECRET = ENV['SECRET_KEY_BASE']
  ALGORITHM = ENV['JWT_ALGORITHM'] || 'HS512'
  DEFAULT_OPTIONS = {
    exp: (Time.now + ENV['JWT_EXPIRATION'].to_i).to_i,
    nbf: Time.now.to_i
  }.freeze
  CUSTOM_OPTIONS = {
    algorithm: ALGORITHM
  }.freeze
end

class DcsJwt
  def self.encode(payload:)
    payload.merge!(DcsJwtDefaults::DEFAULT_OPTIONS)
    JWT.encode(
      payload, DcsJwtDefaults::HMAC_SECRET,
      DcsJwtDefaults::ALGORITHM
    )
  end

  def self.decode(jwt_token:)
    JWT.decode(
      jwt_token,
      DcsJwtDefaults::HMAC_SECRET,
      true,
      DcsJwtDefaults::CUSTOM_OPTIONS
    )
  end
end
