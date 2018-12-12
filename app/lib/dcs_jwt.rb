# frozen_string_literal: true

module DcsJwtDefaults
  HMAC_SECRET = Rails.application.credentials.SECRET_KEY_BASE
  ALGORITHM = Rails.application.credentials.public_send(Rails.env)[:JWT_ALGORITHM] || 'HS512'
  CUSTOM_OPTIONS = {
    algorithm: ALGORITHM
  }.freeze
end

class DcsJwt
  def self.encode(payload:)
    payload = configure_payload(payload: payload)
    JWT.encode(
      payload, DcsJwtDefaults::HMAC_SECRET,
      DcsJwtDefaults::ALGORITHM
    )
  end

  def self.decode(jwt:)
    JWT.decode(
      jwt,
      DcsJwtDefaults::HMAC_SECRET,
      true,
      DcsJwtDefaults::CUSTOM_OPTIONS
    )
  end

  def self.configure_payload(payload:)
    payload[:iat] = Time.now.to_i
    payload[:nbf] = Time.now.to_i
    payload[:exp] = (Time.now + Rails.application.credentials.public_send(Rails.env)[:JWT_EXPIRATION].to_i).to_i
    payload[:jti] = jti
    payload
  end

  def self.jti
    string = "#{SecureRandom.uuid}-#{Time.now}"
    Digest::MD5.hexdigest(string)
  end
end
