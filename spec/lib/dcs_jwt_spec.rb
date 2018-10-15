# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DcsJwt do
  let(:user) { build_stubbed(:user) }

  describe '.encode' do
    it 'creates jwt token' do
      jwt_token = described_class.encode(payload: valid_payload(user))
      expect(jwt_token).not_to be_nil
    end
  end

  describe '.decode' do
    it 'returns jwt_token data' do
      jwt_token = described_class.encode(payload: valid_payload(user))
      expect(described_class.decode(jwt_token: jwt_token)).to be_a(Array)
    end
  end

  describe 'errors' do
    it 'raises ExpiredSignature error when jwt is expired' do
      expect do
        described_class.decode(jwt_token: expired_jwt_token)
      end.to raise_error(JWT::ExpiredSignature, 'Signature has expired')
    end

    it 'raises DecodeError when jwt_token is invalid' do
      jwt_token = 'hbhhvh.njbjb'
      expect do
        described_class.decode(jwt_token: jwt_token)
      end.to raise_error(JWT::DecodeError, 'Not enough or too many segments')
    end

    it 'raises DecodeError when jwt_token is empty' do
      expect do
        described_class.decode(jwt_token: '')
      end.to raise_error(JWT::DecodeError, 'Not enough or too many segments')
    end

    it 'raises DecodeError when jwt is nil' do
      expect do
        described_class.decode(jwt_token: nil)
      end.to raise_error(JWT::DecodeError, 'Nil JSON web token')
    end
  end
end
