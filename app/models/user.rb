# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, :password_digest, presence: true
  validates :email, uniqueness: true
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  def build_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64(20, true)
    save!
    password_reset_token
  end

  def build_password_reset_url
    host, port = User.fetch_host_and_port(Rails.env)
    Rails.application.routes.url_helpers.passwords_url(
      host: host,
      port: port, token: password_reset_token
    )
  end

  def self.fetch_host_and_port(env)
    if env == 'production'
      [ENV['PROD_HOST'], ENV['PROD_PORT']]
    elsif env == 'development'
      [ENV['DEV_HOST'], ENV['DEV_PORT']]
    end
  end
end
