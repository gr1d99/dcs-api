# frozen_string_literal: true

require 'rails_helper'

# /passwords?token=345r4r4&type=reset_password
RSpec.describe 'CreateNewPassword', type: :request do
  describe 'POST #create' do
    let(:user) { build(:user) }
    let(:password) { Faker::Internet.password(6) }
    let(:confirm) { password }
    let(:type) { 'password_reset' }
    let(:token) { user.build_password_reset_token }

    context 'when token, type, password and confirm params are valid' do

      before do
        post passwords_path(type: type, token: token),
             params: { password: password, confirm: confirm }
      end

      it 'responds with status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Password successfully created/)
      end
    end

    context 'when token is not valid' do
      let(:token) { SecureRandom.urlsafe_base64(10, true ) }

      before do
        post passwords_path(type: type, token: token),
             params: { password: password, confirm: confirm }
      end

      it 'responds with status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error message' do
        expect(json['error']).to match(/Page not found/)
      end
    end

    context 'when type is not password reset' do
      let(:type) { 'password_reset_type' }

      before do
        post passwords_path(type: type, token: token),
             params: { password: password, confirm: confirm }
      end

      it 'responds with status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error message' do
        expect(json['error']).to match(/Page not found/)
      end
    end

    context 'when password and confirm are not equal' do
      let(:confirm) { 'Not Entirely true' }

      before do
        post passwords_path(type: type, token: token),
             params: { password: password, confirm: confirm }
      end

      it 'responds with status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error message' do
        expect(json['error']).to match(/Passwords do not match/)
      end
    end
  end
end
