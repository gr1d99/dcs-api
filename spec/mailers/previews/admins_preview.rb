# frozen_string_literal: true

require 'faker'

# Preview all emails at http://localhost:3000/rails/mailers/admins
class AdminsPreview < ActionMailer::Preview
  def invite
    email = Faker::Internet.email
    password = Faker::Internet.password(10)
    AdminsMailer.with(email: email, password: password).invite
  end
end
