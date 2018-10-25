# frozen_string_literal: true

class PasswordsMailer < ApplicationMailer
  default(
    subject: 'Password Reset Instructions',
    from: ENV['ADMINS_DEFAULT_FROM_EMAIL']
  )

  def send_password_reset_link
    @to = params[:user_email]
    @link = params[:link]

    mail(to: @to)
  end
end
