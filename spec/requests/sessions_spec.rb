# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user) }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  describe 'POST /login' do
    context 'when params are correct' do
      before { post '/users/login', params: params }

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns jwt token in Authorization header' do
        expect(response.headers['Authorization']).to be_present
      end

      it 'returns valid jwt token' do
        user_id = decode_jwt_token(response).first['sub']
        expect(user_id.to_i).to eq(user.id)
      end

      it 'returns success message' do
        expect(json['message']).to eql('Successfully logged in')
      end
    end

    context 'when login params are not provided' do
      before { post '/users/login', params: {} }

      it 'returns unauthorized status' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['errors']['message'])
          .to eql('You need to sign in or sign up before continuing.')
      end
    end

    context 'when email and password are incorrect' do
      before do
        post '/users/login', params: { email: user.email, password: '1' }
      end

      it 'returns error message' do
        expect(json['errors']['message']).to eql('Invalid Email or password.')
      end
    end
  end

  describe 'DELETE /logout' do
    before { delete '/users/logout' }

    it 'returns 204 no content' do
      expect(response).to have_http_status(204)
    end
  end
end
