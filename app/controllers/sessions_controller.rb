# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    unless user_authenticated?
      reject_login!
      return
    end

    render json: { jwt_token: jwt_token }, status: :ok
  rescue ActiveRecord::RecordNotFound
    reject_login!
  end

  private

  def login_params
    params.permit(:email, :password).to_h
  end

  def jwt_token
    DcsJwt.encode(payload: { email: login_params[:email] })
  end

  def user
    User.find_by!(email: login_params[:email])
  end

  def user_authenticated?
    user.authenticate(login_params[:password])
  end

  def reject_login!
    render json: { error: 'Incorrect email or password' }, status: :unauthorized
  end
end
