# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VerifyPasswordResetToken', type: :request do
  describe 'GET #verify' do
    let(:token) { SecureRandom.urlsafe_base64(20, true) }
    let(:type) { 'password_reset' }

    context 'when type and token are valid' do
      it 'responds with status code 200' do
        allow(User).to receive(:token_valid?).and_return(true)
        get verify_token_path, params: { type: type, token: token }
        expect(response).to have_http_status(200)
      end
    end

    context 'when type is implemented but token is not valid' do
      before do
        allow(User).to receive(:token_valid?).and_return(false)
        get verify_token_path, params: { type: type, token: token }
      end

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'responds with error message' do
        error_message =
          'please ensure you have the correct url or request a new url'
        expect(
          json['error'])
          .to match(/#{error_message}/)
      end
    end

    context 'when type is implemented and token is not provide' do
      before do
        get verify_token_path, params: { type: type }
      end

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'responds with error message' do
        error_message =
          'please ensure you have the correct url or request a new url'
        expect(json['error']).to match(/#{error_message}/)
      end
    end

    context 'when type is not implemented' do
      before do
        get verify_token_path, params: { type: 'invalid', token: token }
      end

      it 'responds with 422' do
        expect(response).to have_http_status(422)
      end

      it 'responds with error message' do
        expect(json['error']).to match(/not yet implemented!!/)
      end
    end
  end
end
