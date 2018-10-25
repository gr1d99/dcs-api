class PasswordsController < ApplicationController
  def new
    email = params.permit(:email)[:email]
    handle_email_not_provided and return unless email_provided?(email)
    @user = User.find_by_email(email)
    handle_email_provided
  end

  def create; end

  private

  def notify(type)
    if type == 'reset_password'
      @user.build_password_reset_token
      SendPasswordResetLinkJob.perform_later(
        user_email: @user.email,
        link: @user.build_password_reset_url)
    end
  end

  def email_provided?(email)
    string_empty_or_nil?(email)
  end

  def handle_email_not_provided
    render json: {
      error: 'email address required'
    }, status: :unprocessable_entity
  end

  def handle_email_provided
    if @user
      notify('reset_password')
      render json: {
        message: 'Password reset instructions sent to your email'
      }, status: :ok
    else
      render json: { error: 'email not found' }, status: :unprocessable_entity
    end
  end
end
