# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authenticate_user!, :admin_only!

  def add_user
    User.create!(
      user_params.merge(password: random_password)
    )
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
    render json: {
      error: 'You do not have enough permission to make such request '
    }, status: :forbidden
  end
end
