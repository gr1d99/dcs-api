# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Successfully logged in' }
  end

  def respond_to_on_destroy
    head :no_content
  end
end