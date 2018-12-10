# frozen_string_literal: true

module JSONSupport
  def json
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include(JSONSupport, type: :request)
end
