# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:email) { Faker::Internet.email }
  let(:password) { 'test@123' }

  before { FactoryBot.create(:user, email: email, password: password) }

  describe 'POST #create' do
    context 'when email and password are correct' do
      before { post login_path, params: { email: email, password: password } }

      it 'responds with status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns jwt_token' do
        expect(json['jwt_token']).not_to be_nil
      end
    end

    context 'when password is incorrect' do
      before { post login_path, params: { email: email, password: '234' } }

      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns failure error message' do
        expect(json['error']).to match(/Incorrect email or password/)
      end
    end

    context 'when email does not exist' do
      before do
        post login_path, params: { email: 'invalid@example.com', password: password }
      end

      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns failure error message' do
        expect(json['error']).to match(/Incorrect email or password/)
      end
    end
  end
end
