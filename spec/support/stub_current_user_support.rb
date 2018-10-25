# frozen_string_literal: true

module StubCurrentUserSupport
  def stub_current_user_with(user)
    allow_any_instance_of(ApplicationController)
      .to receive(:authenticate_user!).and_return(user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
end

RSpec.configure do |config|
  config.include(StubCurrentUserSupport)
end
