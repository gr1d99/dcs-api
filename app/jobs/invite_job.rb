class InviteJob < ApplicationJob
  queue_as :default

  def perform(email:, password:)
    AdminsMailer.with(
      email: email,
      password: password
    ).invite.deliver_later
  end
end
