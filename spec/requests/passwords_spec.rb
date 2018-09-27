# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  let(:user) { create(:user) }

  describe 'POST /users/password' do

    context 'when email exists' do
      before { request_reset_password(user) }

      it { expect(response).to have_http_status(200) }
      it 'returns success message' do
        expect(json['message'])
          .to eql('Check your e-mail for reset instructions')
      end
    end

    context 'when email does not exist' do
      let(:fake_email) { Faker::Internet.email }
      let(:fake_params) { { user: { email: fake_email } } }

      before { post '/users/password', params: fake_params }

      it { expect(response).to have_http_status(422) }
      it 'has error messages' do
        expect(json['errors']).not_to be_empty
      end
    end
  end
end
