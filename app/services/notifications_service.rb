# frozen_string_literal: true

class NotificationsService
  NOTIFICATION_TYPES = {
    invite_new_user: 'invite new user',
    send_password_reset_link: 'send password reset link'
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

  attr_reader :type,
              :params

  def notify(type, params:)
    p type, params
    options = notification_options(type, params: params)
    NotificationsJob.perform_later(options: options)
  end

  def notification_options(type, params:)
    options = if type == NOTIFICATION_TYPES[:invite_new_user]
                { action_name: 'invite_user',
                  payload: params }
              elsif type == NOTIFICATION_TYPES[:send_password_reset_link]
                { action_name: 'send_password_reset_link',
                  payload: params }
              end
    options[:mailer_name] = NotificationMailer.name
    options
  end
end
