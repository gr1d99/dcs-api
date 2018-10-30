# frozen_string_literal: true

class NotificationsService
  NOTIFICATION_TYPES = {
    invite_new_user: 'invite new user'
  }.freeze

  def initialize(type, params: {})
    @type = type
    @params = params
  end

  def call
    notify(type, params: params)
  end

  def self.call(type, params: {})
    new(type, params: params).call
  end

  private

  attr_reader :type
  attr_reader :params

  def notify(type, params:)
    case type
    when NOTIFICATION_TYPES[:invite_new_user]
      InviteJob.perform_later(email: params[:email], password: params[:password])
    end
  end
end
