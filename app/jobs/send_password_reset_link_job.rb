class SendPasswordResetLinkJob < ApplicationJob
  queue_as :default

  def perform(user_email:, link:)
    PasswordsMailer.with(
      user_email: user_email,
      link: link
    ).send_password_reset_link.deliver_later
  end
end
