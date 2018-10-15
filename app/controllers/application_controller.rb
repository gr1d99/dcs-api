# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  private

  attr_reader :current_user

  def invalid_record(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def jwt_token_required
    render json: { error: 'jwt token required' }, status: :unauthorized
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
    @current_user = User.find_by_email(user_email)
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
