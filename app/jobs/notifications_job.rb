class NotificationsJob < ApplicationJob
  queue_as :default

  def perform(options:)
    mailer = mailer_klass(options[:mailer_name])
    action = options[:action_name].to_sym
    mailer.with(payload: options[:payload]).send(action).deliver_later
  end

  private

  def mailer_klass(mailer_name)
    Object.const_get(mailer_name.to_sym)
  end
end
