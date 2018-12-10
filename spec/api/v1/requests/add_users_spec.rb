# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  describe 'admin user POST #add_user' do
    let(:admin_user) do
      create(:user).tap do |user|
        user.is_admin = true
        user.save!
      end
    end
    let(:headers) { { Authorization: "Bearer #{valid_jwt_token(admin_user)}" } }

    context 'when email is valid' do
      let(:email) { Faker::Internet.email }

      it 'returns status code 201' do
        post api_v1_add_user_path, params: { email: email }, headers: headers

        expect(response).to have_http_status(201)
      end

      it 'changes users count by 1' do
        expect do
          post api_v1_add_user_path, params: { email: email }, headers: headers
        end.to change(User, :count)
      end
    end

    context 'when email is taken' do
      let(:email) { Faker::Internet.email }

      before do
        FactoryBot.create(:user, email: email)
        post api_v1_add_user_path, params: { email: email }, headers: headers
      end

      include_examples 'status code 422'
      it 'returns error message' do
        expect(json[:email][0]).to match(/has already been taken/)
      end
    end

    context 'when email is of incorrect format' do
      before do
        post api_v1_add_user_path, params: { email: 'email' }, headers: headers
      end

      include_examples 'status code 422'
      it 'returns error message' do
        expect(json[:email][0]).to match(/is invalid/)
      end
    end
  end

  describe 'non admin user' do
    let(:non_admin) { create(:user) }
    let(:new_user_params) { { email: 'new@example.com' } }
    let(:headers) { { Authorization: "Bearer #{valid_jwt_token(non_admin)}" } }

    it 'returns status code 403' do
      post api_v1_add_user_path,
           params: new_user_params,
           headers: headers
      expect(response).to have_http_status(403)
    end
  end
end
