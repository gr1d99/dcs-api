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

  def jwt_token_revoked
    render json: { error: 'token has been revoked, please login again' }, status: :unauthorized
  end

  def page_not_found
    responder('error', :not_found, error: 'Page not found')
  end

  def authenticate_user!
    unless auth_token_valid?
      jwt_token_required
      return
    end
    jwt_token_revoked if token_revoked?
    user = Users::AuthorizeUserService.call(auth_token: auth_token)
    instance_variable_set(:@current_user, user)
  end

  def auth_token_valid?
    return true unless auth_token.nil?
    false
  end

  def token_revoked?
    Blacklist.jti_exists?(raw_jti)
  end

  def auth_token
    request.env['HTTP_AUTHORIZATION']
  end

  def raw_jti
    DcsJwt.decode(jwt: auth_token.split.last)[0]['jti']
  end

  def responder(type, status, message: nil, error: nil)
    case type
    when 'success'
      render json: { message: message }, status: status
    when 'error'
      render json: { error: error }, status: status
    else
      raise('Invalid type!!')
    end
  end

  def string_empty_or_nil?(string)
    return false if string.is_a?(NilClass)
    return false if string.is_a?(String) && string.empty?
    true
  end

  def notify(type, params: {})
    NotificationsService.call(type, params: params)
  end
end
