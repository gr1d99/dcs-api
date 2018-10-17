# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from JWT::ExpiredSignature, with: :expired_signature
  rescue_from JWT::DecodeError, with: :invalid_jwt

  private

  attr_reader :current_user

  def invalid_record(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def expired_signature(error)
    render json: { error: error.message }, status: :unauthorized
  end

  def jwt_token_required
    render json: { error: 'jwt token required' }, status: :unauthorized
  end

  def invalid_jwt(*)
    render json: { error: 'invalid jwt token' }, status: :unauthorized
  end

  def random_password
    SecureRandom.urlsafe_base64(10)
  end

  def authenticate_user!
    unless authorization_header_valid?
      jwt_token_required
      return
    end
    user_email = DcsJwt.decode(jwt_token: jwt_token)[0]['email']
    user = User.find_by_email(user_email)
    instance_variable_set(:@current_user, user)
  end

  def jwt_token
    authorization_header.split(' ').last
  end

  def authorization_header_valid?
    return true unless authorization_header.nil?
    false
  end

  def authorization_header
    request.env['HTTP_AUTHORIZATION']
  end
end
