class AdminsMailer < ApplicationMailer
  default from: ENV['ADMINS_DEFAULT_FROM_EMAIL']

  def invite
    @subject = 'Welcome to DCS'
    @to = params[:email]
    @password = params[:password]
    mail(to: @to, subject: @subject)
  end
end
