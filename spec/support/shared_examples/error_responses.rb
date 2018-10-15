# frozen_string_literal: true

RSpec.shared_examples 'status code 422' do
  it 'returns status code 422' do
    expect(response).to have_http_status(422)
  end
end
