class NotificationMailer < ApplicationMailer
  default from: Rails.application.credentials.public_send(Rails.env)[:ADMINS_DEFAULT_FROM_EMAIL]

  def invite_user
    @subject = 'Welcome to DCS'
    @to = params[:payload][:email]
    @password = params[:payload][:password]
    mail(to: @to, subject: @subject)
  end

  def send_password_reset_link
    @to = params[:payload][:user_email]
    @link = params[:payload][:link]
    mail(to: @to, subject: 'Password Reset Instructions')
  end
end
