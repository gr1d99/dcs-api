# frozen_string_literal: true

module ActionMailerSupport
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def all_emails
    ActionMailer::Base.deliveries
  end
end

RSpec.configure do |config|
  config.include(ActionMailerSupport, type: :job)
  config.include(ActionMailerSupport, type: :mailer)
  config.before { ActionMailer::Base.deliveries.clear }
end
