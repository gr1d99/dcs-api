# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NewPassword', type: :request do
  describe 'GET #new' do
    before do
      allow(User)
        .to receive(:fetch_host_and_port).and_return(%w[test 80])
    end

    context 'when user provides email address that exists' do
      let(:user) { build(:user) }

      before { allow(User).to receive(:find_by_email).and_return(user) }

      it 'responds with status code 200' do
        get new_password_path, params: { email: user.email }
        expect(response).to have_http_status(200)

      end

      it 'returns success message' do
        get new_password_path, params: { email: user.email }
        expect(json['message'])
          .to match(/Password reset instructions sent to your email/)
      end
    end

    context 'when email address does not exist' do
      before do
        allow(User).to receive(:find_by_email).and_return(nil)
        get new_password_path, params: { email: 'idontexist@test.com' }
      end

      it 'responds with status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error message' do
        expect(json['error']).to match(/email not found/)
      end
    end

    context 'when email is nil or empty' do
      before { get new_password_path, params: { email: '' } }

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error message' do
        expect(json['error']).to match(/email address required/)
      end
    end
  end
end
