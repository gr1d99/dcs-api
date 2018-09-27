# frozen_string_literal: true

class PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    super do
      unless successfully_sent?(resource)
        render json: { errors: resource.errors}, status: :unprocessable_entity
        return
      end

      render json: { message: 'Check your e-mail for reset instructions' }
      return
    end
  end

  def update
    super do
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        set_minimum_password_length
        render json: { errors: resource.errors }, status: :unprocessable_entity
      end

      return
    end
  end
end
