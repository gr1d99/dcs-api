# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authenticate_user!, :admin_only!

  def add_user
    user_password = SecureRandom.urlsafe_base64(10)
    User.create!(user_params.merge(password: user_password))
    notify('invite new user',
           params: { email: params[:email], password: user_password })
    render json: { message: 'User created successfully' }, status: :created
  end

  private

  def user_params
    params.permit(:email)
  end

  def admin_only!
    forbidden_access unless current_user.is_admin
  end

  def forbidden_access
    responder('error',
              :forbidden,
              error: 'You do not have enough permission to make such request ')
  end
end
