# frozen_string_literal: true

module PasswordsHelper
  def request_reset_password(user)
    post '/users/password', params: { user: { email: user.email } }
  end

  def change_password(user)
    p user
  end
end

RSpec.configure do |config|
  config.include PasswordsHelper
end
