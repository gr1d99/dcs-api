# frozen_string_literal: true

require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.configure do |config|
  config.include(ActiveJob::TestHelper)
  config.before { Sidekiq::Worker.clear_all }
end
