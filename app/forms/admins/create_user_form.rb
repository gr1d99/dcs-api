# frozen_string_literal: true
require "reform/form/validation/unique_validator"

module Admins
  class CreateUserForm < Reform::Form
    property :email
    property :password

    validates :email,
              presence: true,
              unique: true,
              format: { with: URI::MailTo::EMAIL_REGEXP}
  end
end
