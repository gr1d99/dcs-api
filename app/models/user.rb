# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
