# frozen_string_literal: true

require 'ostruct'

module Admins
  class CreateUserService
    def initialize(args = {})
      @email = args[:email]
    end

    def call
      create_user(generate_password)
    end

    def self.call(args)
      new(args).call
    end

    private

    attr_reader :email

    def generate_password
      SecureRandom.urlsafe_base64(10)
    end

    def create_user(password)
      form = Admins::CreateUserForm.new(User.new)
      if form.validate(email: email, password: password)
        form.save
        invite_user(password)
        OpenStruct.new(success?: true, model: form.model)
      else
        OpenStruct.new(success?: false, model: form)
      end
    end

    def invite_user(password)
      NotificationsService.call(I18n.t('mailers.types.invite_user'),
                                params: { email: email, password: password })
    end
  end
end
